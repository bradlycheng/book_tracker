# Orchestrator Protocol

Driver-agnostic protocol for continuing this repo's improvement backlog unattended. Any driver (Claude Code tonight; a local Ollama-backed script later) should be able to read this file plus `TASKS.md`/`.orchestrator/state.md`/`LEDGER.md` and execute correctly with nothing more than shell + git + string parsing. No conversation memory is assumed — every firing is a fresh context.

## Files
- `TASKS.md` — the backlog, one task per `## TASK-NNN` section. File order = priority order.
- `LEDGER.md` — append-only audit trail, one block per *attempt* (not per task).
- `.orchestrator/state.md` — run-level counters that must persist across fresh contexts.

## Hard guardrails (never violate these, ever)
- **Never delete, force-push, or rewrite history on ANY branch** — not `graphql-api`, not `main`, not `ai-orchestrate`, not any other branch in this repo.
- **Never push to or merge into `main`.** All work stays on `graphql-api`. A human opens the PR.
- **Never run an interactive/blocking command.** Everything (bundle, generators, tests) must run non-interactively with an explicit timeout. A hang must become a logged FAIL/INTERRUPTED, never silence.
- **The gate is `bin/rails db:test:prepare test` only.** No rubocop/brakeman/bundler-audit/system tests block a commit (they still run for real on GitHub Actions once a PR is opened — this is a deliberate, confirmed tradeoff, not an oversight).

## Task schema (`TASKS.md`)
Each task is a `## TASK-NNN` section with these fields:
```
status: pending | in_progress | done | failed | blocked
title: <short description>
depends_on: none | TASK-NNN[, TASK-NNN...]
attempts: <int>
max_attempts: 3
description: |
  <what to build>
acceptance: |
  <bullet list of concrete, checkable acceptance criteria>
notes: <optional freeform, appended by the driver as it learns things>
```

## Ledger schema (`LEDGER.md`)
Append one block per *attempt* at the bottom of the file:
```
## <ISO8601 timestamp> — TASK-NNN attempt N
task: TASK-NNN (<title>)
result: PASS | FAIL | INTERRUPTED
files_touched: <comma-separated paths, or none>
test_summary: <final summary line of `bin/rails test`, or a description if INTERRUPTED>
commit_sha: <sha, or "(none - reverted)">
error: |
  <full error/failure text if FAIL, or what was found dirty if INTERRUPTED, else omit this field>
---
```

## Per-iteration algorithm
Run this exactly, every firing:

1. **Stop-condition check first** (before touching any code). Read `.orchestrator/state.md`.
   - If `run_status` is already `stopped_*` → no-op, end turn immediately without doing anything else.
   - If `run_status: not_started` → set `run_started_at` to the current UTC timestamp and `run_status: running`, then continue (this is initialization, not a stop condition).
   - If `iteration_count >= 40` → set `run_status: stopped_max_iterations`.
   - If elapsed minutes since `run_started_at` >= 480 → set `run_status: stopped_max_wall_clock`.
   - If `consecutive_failures >= 3` → set `run_status: stopped_max_consecutive_failures`.
   - If no task in `TASKS.md` has `status: pending` or `status: in_progress` → set `run_status: stopped_backlog_complete`.
   - On any `stopped_*` above: write the reason to `state.md`, append a closing summary block to `LEDGER.md`, commit `state.md` (+ `TASKS.md` if changed) as `orchestrator: run stopped (<reason>)`, end turn. Do not schedule another firing (see step 8).

2. **Resume-safety.** Run `git status --porcelain`.
   - If dirty: a previous iteration was interrupted (crash, host sleep, user interrupt) before finishing. Find which task is `in_progress` in `TASKS.md`. Append an `INTERRUPTED` entry to `LEDGER.md` for that task's current attempt, describing what was found dirty (`git status --porcelain` / `git diff --stat` output). Then `git reset --hard HEAD && git clean -fd`. The task's `attempts` counter (already incremented when that attempt's Phase 1 ran) stays as-is — an interrupted attempt still counts against `max_attempts`.
   - If clean: continue.

3. **Pick task.** First `## TASK-NNN` in file order with `status: pending` where every id in `depends_on` is `status: done` (or `depends_on: none`). If no task qualifies (remaining pending tasks are all blocked on unmet dependencies), treat like an empty backlog and go to the stop path in step 1.

4. **Phase 1 — bookkeeping commit.** In `TASKS.md`, set the picked task's `status: in_progress`, `attempts: N+1`. Commit alone: `git commit -am "orchestrator: begin TASK-NNN attempt N"`. This commit cannot fail a gate and becomes the safe rollback point for step 6's FAIL path.

5. **Phase 2 — implementation.** Make the actual code/test changes described by the task. Stay scoped to exactly what the task describes — do not scope-creep into other tasks' work, and do not add new tasks to the backlog (this loop works a fixed checklist by design).

6. **Phase 3 — gate.** Run `bin/rails db:test:prepare test`, non-interactively, with a ~300s timeout.
   - **PASS** (exit 0, "0 failures, 0 errors"): set task `status: done` in `TASKS.md`. Append a `PASS` entry to `LEDGER.md` (test summary line + files touched). Set `consecutive_failures: 0` in `state.md`. Commit everything as one commit: `[orchestrator] TASK-NNN: <title>` (body notes the gate result). Push `graphql-api` to `origin` — a plain push, never `--force`.
   - **FAIL** (nonzero exit, timeout, or any failures/errors): `git reset --hard HEAD && git clean -fd` (drops Phase 2's broken changes; Phase 1's bookkeeping commit survives, it's already in HEAD). In `TASKS.md` set the task `status: pending` if `attempts < max_attempts` else `status: blocked`. Append a `FAIL` entry to `LEDGER.md` with the real error/test output. Increment `consecutive_failures` in `state.md`. Commit the bookkeeping update alone: `orchestrator: TASK-NNN attempt N failed`.

7. Increment `iteration_count` in `state.md` (commit alongside whichever commit above hasn't happened yet, or as its own small commit if needed).

8. **Schedule the next firing.** If `run_status` just became `stopped_*` in step 1: stop the recurring loop entirely (no further firings). Otherwise, if backlog still has `pending`/`in_progress` work: re-fire soon (~60–120s — there's concrete queued work, not a poll; do **not** inherit a long idle-tick default here, that would waste most of an overnight budget waiting instead of working). End the turn with exactly one status line: `ITERATION COMPLETE: TASK-NNN <PASS|FAIL>, X/Y done` or `RUN STOPPED: <reason>`.

## Interrupts
- **Accidental** (crash, host/WSL sleep, killed mid-gate, user interrupts a turn): handled automatically by step 2, with a trail (an `INTERRUPTED` ledger entry) so the gap is never silent.
- **Intentional stop:** a human may hand-edit `.orchestrator/state.md` to `run_status: stopped_manual` at any time, even without touching the live session — the very next firing sees this in step 1 and no-ops.
- **Resuming:** clear `run_status` back to `running` (or `not_started`) and start the driver again. All state is file-based, not memory-based, so a pause of any length resumes identically.

## Known, accepted limitations (do not try to "fix" these mid-run — they're deliberate tradeoffs)
- The gate proves internal consistency (tests the same run wrote still pass), not correctness — a human review of the branch is the real quality gate, not this loop.
- The backlog is fixed at `TASKS.md`'s seeded contents; the loop marks tasks `blocked` rather than inventing new ones.
- Thread-based concurrency tests in this suite are more flake-prone than average; a spurious flake can block an unrelated task and cost it a retry attempt.

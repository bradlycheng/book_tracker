---
name: orchestrate
description: One iteration of the book_tracker GraphQL orchestrator loop (test-gated, ledgered, autonomous).
---

You are running **ONE iteration** of the autonomous orchestrator loop for the `book_tracker` Rails app. This command is re-invoked repeatedly by `/loop` in dynamic self-pacing mode — you have **no memory of previous firings**. Everything you need is on disk. Follow `.orchestrator/PROTOCOL.md` exactly; this file is just the entry point into it.

The repo lives in WSL Ubuntu, not the Windows filesystem. Every command must go through:
`wsl -d Ubuntu -- bash -lc "cd ~/book_tracker && <command>"`

Steps:

1. Read `.orchestrator/PROTOCOL.md` in full (the rules — do not rely on memory of them from a prior turn).
2. Read `.orchestrator/state.md` in full.
3. Read `TASKS.md` in full.
4. Read only the **tail** of `LEDGER.md` (e.g. `tail -n 150 LEDGER.md`) — never the whole file, it grows every iteration.
5. Confirm you're on git branch `graphql-api` (`git branch --show-current`). If not, stop and report — do not proceed on the wrong branch.
6. Execute the per-iteration algorithm from `PROTOCOL.md` exactly, in order: stop-condition check → resume-safety → pick task → Phase 1 bookkeeping commit → Phase 2 implementation → Phase 3 gate (`bin/rails db:test:prepare test`, non-interactive, ~300s timeout) → commit+push on PASS or revert+record on FAIL → update `TASKS.md`/`LEDGER.md`/`state.md` accordingly.
7. Guardrails (non-negotiable, restated from `PROTOCOL.md`): never delete/force-push/rewrite history on any branch; never push or merge to `main`; never run an interactive/blocking command without a timeout; the gate is `bin/rails db:test:prepare test` only — nothing else blocks a commit.
8. Before ending the turn, decide the next wakeup:
   - If you just set a `stopped_*` run_status: call `ScheduleWakeup` with `stop: true`. The run is over.
   - Else if the backlog still has `pending`/`in_progress` tasks: call `ScheduleWakeup` with `delaySeconds: 90`, `prompt: "/orchestrate"`, and a one-line `reason` describing what's next.
   - (An empty backlog with nothing pending should already have triggered a stop in step 6/PROTOCOL step 1 — this branch shouldn't normally be reached.)
9. End your turn with **exactly one** status line: `ITERATION COMPLETE: TASK-NNN <PASS|FAIL>, X/Y done` or `RUN STOPPED: <reason>`. Keep everything else minimal — this runs unattended overnight, there's no one reading verbose narration.

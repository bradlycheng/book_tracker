---
name: orchestrate
description: One iteration of the book_tracker GraphQL orchestrator loop (test-gated, ledgered, autonomous).
---

You are running **ONE iteration** of the autonomous orchestrator loop for the `book_tracker` Rails app. This command is re-invoked repeatedly by `/loop` in dynamic self-pacing mode — you have **no memory of previous firings**. Everything you need is on disk. Follow `.orchestrator/PROTOCOL.md` exactly; this file is the entry point plus the operational quirks discovered getting TASK-001 working, which you must account for or the first real iteration will fail on infrastructure, not code.

## Environment quirks (discovered during the manual TASK-001 dry run — do not relearn these the hard way)

The repo lives in WSL Ubuntu (`~/book_tracker`), not the Windows filesystem. This session's Bash tool has three real quirks when bridging to `wsl`:

1. **Bare `$VAR` references silently evaluate to empty** inside an inline `wsl -d Ubuntu -- bash -c '...'` string, even though `$(command substitution)` works fine. Root cause not fully diagnosed — treat as a hard rule: **never** put a variable assignment + later reference (`X=...; echo $X`) inline in a single `wsl ... bash -c '...'` call. Instead, write real multi-line scripts to a file and execute the file. Variables work fine *inside* a script file executed this way.
2. **`/mnt/c/...` path arguments get mangled** by Git-Bash's automatic path conversion (turns into something like `C:/Program Files/Git/mnt/c/...`). Fix: prefix the outer command with `MSYS_NO_PATHCONV=1`.
3. **Non-login script execution doesn't source rbenv** — `bundle`/`bin/rails` aren't on `PATH` unless you `export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"` at the top of every script.

**Working pattern, every time:**
- Write the iteration's shell logic to a script file on the Windows side, e.g. `C:\Users\bradl\AppData\Local\Temp\book_tracker_orchestrator\<step>.sh` (create the dir if needed; a fresh file per step is fine, no need to reuse names across firings).
- Script content always starts with:
  ```bash
  #!/bin/bash
  set -e
  export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
  cd ~/book_tracker
  ```
- Execute it as: `MSYS_NO_PATHCONV=1 wsl -d Ubuntu -- bash /mnt/c/Users/bradl/AppData/Local/Temp/book_tracker_orchestrator/<step>.sh`
- Any command that could possibly prompt (bundler, Rails generators, git) must redirect `< /dev/null` and be wrapped in `timeout <seconds>` — confirmed necessary and sufficient in practice (EOF-on-read makes prompts fail fast instead of hanging).

## Steps

1. Read `.orchestrator/PROTOCOL.md` in full (the rules — do not rely on memory of them from a prior turn).
2. Read `.orchestrator/state.md` in full.
3. Read `TASKS.md` in full.
4. Read only the **tail** of `LEDGER.md` (e.g. `tail -n 150 LEDGER.md`) — never the whole file, it grows every iteration.
5. Confirm you're on git branch `graphql-api` (`git branch --show-current`). If not, stop and report — do not proceed on the wrong branch.
6. Execute the per-iteration algorithm from `PROTOCOL.md` exactly, in order: stop-condition check → resume-safety → pick task → Phase 1 bookkeeping commit → Phase 2 implementation → Phase 3 gate (`bin/rails db:test:prepare test`, non-interactive, ~300s timeout) → commit+push on PASS or revert+record on FAIL → update `TASKS.md`/`LEDGER.md`/`state.md` accordingly. Use the environment pattern above for every shell interaction.
7. Guardrails (non-negotiable, restated from `PROTOCOL.md`): never delete/force-push/rewrite history on any branch; never push or merge to `main`; never run an interactive/blocking command without a timeout; the gate is `bin/rails db:test:prepare test` only — nothing else blocks a commit.
8. Before ending the turn, decide the next wakeup:
   - If you just set a `stopped_*` run_status: call `ScheduleWakeup` with `stop: true`. The run is over.
   - Else if the backlog still has `pending`/`in_progress` tasks: call `ScheduleWakeup` with `delaySeconds: 90`, `prompt: "/orchestrate"`, and a one-line `reason` describing what's next.
   - (An empty backlog with nothing pending should already have triggered a stop in step 6/PROTOCOL step 1 — this branch shouldn't normally be reached.)
9. End your turn with **exactly one** status line: `ITERATION COMPLETE: TASK-NNN <PASS|FAIL>, X/Y done` or `RUN STOPPED: <reason>`. Keep everything else minimal — this runs unattended overnight, there's no one reading verbose narration.

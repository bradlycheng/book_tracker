# Orchestrator Ledger

Append-only. One block per attempt (not per task). Newest entries at the bottom.

## 2026-08-09T01:58:39Z — orchestrator init
task: none
result: PASS
files_touched: .orchestrator/PROTOCOL.md, .orchestrator/state.md, TASKS.md, LEDGER.md, .claude/commands/orchestrate.md
test_summary: n/a (scaffolding only, no application code changed)
commit_sha: (set on commit)
error: |
  n/a
---

## 2026-08-09T02:05:49Z — TASK-001 attempt 1
task: TASK-001 (Add graphql-ruby gem, run install generator, fix CSRF for JSON API)
result: PASS
files_touched: Gemfile,Gemfile.lock,config/application.rb,config/routes.rb,app/controllers/graphql_controller.rb,app/graphql/
test_summary: 11 runs, 20 assertions, 0 failures, 0 errors, 0 skips
commit_sha: 2558b57d500cd13338b681661342bbff708087f4
error: |
  n/a
---

## 2026-08-09T02:10:47Z — TASK-002 attempt 1
task: TASK-002 (Add presence validations to Book model)
result: PASS
files_touched: app/models/book.rb,test/models/book_test.rb
test_summary: 13 runs, 26 assertions, 0 failures, 0 errors, 0 skips
commit_sha: e6c04b74b8adf916f188ccc3924c8800eda39a7a
error: |
  n/a
---

## 2026-08-09T02:14:04Z — TASK-003 attempt 1
task: TASK-003 (Define Types::BookType)
result: PASS
files_touched: app/graphql/types/book_type.rb,test/graphql/
test_summary: 14 runs, 34 assertions, 0 failures, 0 errors, 0 skips
commit_sha: 39bca9d3a1e77cbf434197206c9e80b71f408b45
error: |
  n/a
---

## 2026-08-09T02:16:57Z — TASK-004 attempt 1
task: TASK-004 (QueryType#books and #book(id:))
result: PASS
files_touched: app/graphql/types/query_type.rb,test/integration/graphql_queries_test.rb
test_summary: 17 runs, 37 assertions, 0 failures, 0 errors, 0 skips
commit_sha: 1c346e98805f103bf91421c29774bc2263121d8a
error: |
  n/a
---

## 2026-08-09T02:19:59Z — TASK-005 attempt 1
task: TASK-005 (Mutations::CheckOutBook)
result: PASS
files_touched: app/graphql/types/mutation_type.rb,app/graphql/mutations/check_out_book.rb,test/integration/graphql_check_out_book_test.rb
test_summary: 19 runs, 46 assertions, 0 failures, 0 errors, 0 skips
commit_sha: 69ef48901993eadb699494907d07f27ba5736a9a
error: |
  n/a
---

## 2026-08-09T02:22:52Z — TASK-006 attempt 1
task: TASK-006 (Mutations::CheckInBook)
result: PASS
files_touched: app/graphql/types/mutation_type.rb,app/graphql/mutations/check_in_book.rb,test/integration/graphql_check_in_book_test.rb
test_summary: 21 runs, 55 assertions, 0 failures, 0 errors, 0 skips
commit_sha: d0055f5a796a28e6fec7e7e4d219490e6ce748ef
error: |
  n/a
---

## 2026-08-09T02:25:55Z — TASK-007 attempt 1
task: TASK-007 (Mutations::CreateBook)
result: PASS
files_touched: app/graphql/types/mutation_type.rb,app/graphql/mutations/create_book.rb,test/integration/graphql_create_book_test.rb
test_summary: 23 runs, 68 assertions, 0 failures, 0 errors, 0 skips
commit_sha: b8d0bcf63232f53958a489822f3607972536c323
error: |
  n/a
---

## 2026-08-09T02:28:56Z — TASK-008 attempt 1
task: TASK-008 (Mutations::UpdateBook)
result: PASS
files_touched: app/graphql/types/mutation_type.rb,app/graphql/mutations/update_book.rb,test/integration/graphql_update_book_test.rb
test_summary: 25 runs, 75 assertions, 0 failures, 0 errors, 0 skips
commit_sha: c643030ac9e58f43dbe582364c00faf57f957297
error: |
  n/a
---

## 2026-08-09T02:32:07Z — TASK-009 attempt 1
task: TASK-009 (Malformed query error handling)
result: PASS
files_touched: test/integration/graphql_malformed_query_test.rb
test_summary: 27 runs, 82 assertions, 0 failures, 0 errors, 0 skips
commit_sha: d0e7b522a284a056c8b63074de1d93a27b9d84f0
error: |
  n/a
notes: |
  graphql-ruby's default GraphqlController already returns a proper
  {"errors":[...]} shape with HTTP 200 for malformed/invalid queries
  (verified manually via curl before writing this test) - no code fix
  was needed, only tests to lock in the existing correct behavior.
---

## 2026-08-09T02:34:58Z — TASK-010 attempt 1
task: TASK-010 (README documentation for GraphQL API)
result: PASS
files_touched: README.md
test_summary: 27 runs, 82 assertions, 0 failures, 0 errors, 0 skips
commit_sha: d137c65a7485733f363dcfce14c613883396b8be
error: |
  n/a
---

## 2026-08-09T02:35:21Z — orchestrator run stopped
task: none
result: PASS
files_touched: none
test_summary: |
  RUN SUMMARY: 10/10 tasks done, 0 blocked, 0 failed attempts, 0 interrupted
  attempts across the whole run. 10 iterations total. Final gate: 27 runs,
  82 assertions, 0 failures, 0 errors, 0 skips (up from an 11-test baseline).
commit_sha: d23419141837eb80199c6f1bcaacfb92372c4409
error: |
  n/a
notes: |
  run_status: stopped_backlog_complete - all TASKS.md entries are status:
  done. Nothing left to do; loop is not re-scheduling further wakeups.
---

## 2026-08-09T02:50:22Z — manual follow-up (post-loop test review)
task: none (manual, requested by user after loop completion)
result: PASS
files_touched: test/integration/graphql_check_out_book_test.rb,test/integration/graphql_check_in_book_test.rb,test/integration/graphql_update_book_test.rb
test_summary: 30 runs, 94 assertions, 0 failures, 0 errors, 0 skips (up from 27)
commit_sha: 998923aea6928e3e3a5db39d85fa005e12c38687
error: |
  n/a
notes: |
  User asked to review the test suite for flaws post-run. Found that
  CheckOutBook, CheckInBook, and UpdateBook all have a "Book not found"
  error branch (unless book -> return early) with zero test coverage -
  only the read-only book(id:) query tested the missing-id case. Added
  one test per mutation covering this branch. Not part of the original
  TASKS.md backlog; a direct manual fix outside the loop.
---

## 2026-08-09T02:51:55Z — manual follow-up (post-loop test review, part 2)
task: none (manual, requested by user after loop completion)
result: PASS
files_touched: test/integration/graphql_create_book_test.rb,test/integration/graphql_update_book_test.rb
test_summary: 32 runs, 103 assertions, 0 failures, 0 errors, 0 skips (up from 30)
commit_sha: 2f870c1999a7f5d6a429351ea14fdcdcd69f8a22
error: |
  n/a
notes: |
  Closes the second flaw noted in review: blank-author was untested on
  createBook/updateBook (only blank-title was). Symmetric coverage added.
---

## 2026-08-13T15:35:39Z — manual workstream (new branch: checkout-model)
task: none (manual, requested by user; not part of the closed TASKS.md backlog)
result: PASS
files_touched: db/migrate/20260813153115_create_checkouts.rb,db/migrate/20260813153116_backfill_checkouts_from_books.rb,db/migrate/20260813153117_remove_checked_out_and_due_date_from_books.rb,app/models/checkout.rb,app/models/book.rb,app/graphql/types/checkout_type.rb,app/graphql/types/book_type.rb,app/graphql/types/query_type.rb,app/controllers/books_controller.rb,test/fixtures/books.yml,test/models/checkout_test.rb,test/models/book_test.rb,test/models/book_race_test.rb,test/models/book_concurrency_test.rb,test/controllers/books_controller_test.rb,test/integration/graphql_check_out_book_test.rb,test/integration/graphql_check_in_book_test.rb,test/integration/graphql_queries_test.rb,test/graphql/types/checkout_type_test.rb
test_summary: 40 runs, 128 assertions, 0 failures, 0 errors, 0 skips (up from 32 baseline)
commit_sha: (set below)
error: |
  n/a
notes: |
  Branched off add-query-first (which had already added due_date and
  books(first:) on top of the original graphql-api backlog, outside the
  loop). Replaces the checked_out boolean column + with_lock pessimistic
  locking on Book with a Checkout model: one row per checkout
  (book_id, checked_out_at, due_date, returned_at), with a partial unique
  index on checkouts(book_id) WHERE returned_at IS NULL. That index is the
  actual fix - a concurrent second open checkout for the same book now
  raises ActiveRecord::RecordNotUnique at the database layer instead of
  relying on with_lock to serialize the check-then-write. Book#check_out!
  and #check_in! no longer take any lock at all.

  checked_out and due_date columns removed from books; both are now
  derived from the book's open_checkout association. A migration backfills
  any pre-existing checked_out: true rows into an open Checkout before the
  columns are dropped. book.checkouts gives full loan history (most recent
  first), exposed via GraphQL as Types::CheckoutType and a new 
  field on BookType - REST view and existing checkedOut/dueDate call sites
  are unchanged since Book still exposes those as methods.

  book_race_test.rb was rewritten: it used to document the double-checkout
  bug by inlining a naive check-then-write against the boolean column
  (both threads succeeded). That bug can't be reproduced against the new
  schema - even the same naive inlined pattern now hits the unique index
  and only one thread's insert survives - so the test now asserts that
  directly, in place of documenting a bug that no longer exists.

  Verified manually end-to-end against a booted dev server: checkOutBook,
  a second checkOutBook while open (fails cleanly via the RecordNotUnique
  rescue, no 500), checkInBook, and the checkouts history field.
  bin/rubocop run against changed files (pre-existing offenses only, all
  in unmodified GraphQL array-literal style shared with unrelated code
  paths - not introduced here). bin/brakeman: 0 warnings.
---

# Task Backlog
protocol_version: 1

## TASK-001
status: done
title: Add graphql-ruby gem, run install generator, fix CSRF for JSON API
depends_on: none
attempts: 1
max_attempts: 3
description: |
  Run `bundle add graphql` and `bin/rails generate graphql:install`.
  In the generated `app/controllers/graphql_controller.rb`, add
  `skip_before_action :verify_authenticity_token` (GraphqlController
  inherits ApplicationController's default CSRF protection, which the
  install generator does not disable; without this, POST /graphql
  from anywhere but GraphiQL's own view will 422 in real use even
  though config/environments/test.rb disables forgery protection for
  tests and would hide the bug).
acceptance: |
  - Gemfile / Gemfile.lock includes graphql
  - config/routes.rb has a POST /graphql route (from the installer)
  - app/controllers/graphql_controller.rb has skip_before_action :verify_authenticity_token
  - bin/rails runner 'true' exits 0 (app boots)
  - bin/rails db:test:prepare test passes with no regression vs the current 11-test baseline
notes:

## TASK-002
status: done
title: Add presence validations to Book model
depends_on: none
attempts: 1
max_attempts: 3
description: |
  Add `validates :title, presence: true` and
  `validates :author, presence: true` to app/models/book.rb, alongside
  the existing check_out!/check_in! methods. Add model tests covering
  a Book without title/author failing validation.
acceptance: |
  - app/models/book.rb has both validations
  - test/models/book_test.rb has tests asserting a Book missing title
    or author is invalid
  - bin/rails db:test:prepare test passes
notes:

## TASK-003
status: done
title: Define Types::BookType
depends_on: TASK-001
attempts: 1
max_attempts: 3
description: |
  Create app/graphql/types/book_type.rb exposing id, title, author,
  checkedOut (mapped from checked_out) as GraphQL fields.
acceptance: |
  - Types::BookType exists with fields id, title, author, checkedOut
  - bin/rails db:test:prepare test passes
notes:

## TASK-004
status: done
title: QueryType#books and #book(id:)
depends_on: TASK-003
attempts: 1
max_attempts: 3
description: |
  Add `books` (returns Book.order(:title)) and `book(id: ID!)`
  fields/resolvers to the generated QueryType, using Types::BookType.
  Add a request test posting `{ books { title author checkedOut } }`
  to /graphql against fixtures, and a request test for a single
  book(id:) lookup.
acceptance: |
  - QueryType has books and book(id:) resolvers
  - A test covers both queries against fixture data
  - bin/rails db:test:prepare test passes
notes:

## TASK-005
status: done
title: Mutations::CheckOutBook
depends_on: TASK-003
attempts: 1
max_attempts: 3
description: |
  Add app/graphql/mutations/check_out_book.rb (id: ID! argument),
  calling book.check_out!. Return the book plus success/errors fields
  (not a hard GraphQL-level error) so "already checked out" behaves
  like the REST controller's alert case. Wire into MutationType.
acceptance: |
  - Mutations::CheckOutBook exists and is exposed on MutationType
  - Tests cover a successful checkout and checkout of an
    already-checked-out book (returns success: false, not a crash)
  - bin/rails db:test:prepare test passes
notes:

## TASK-006
status: done
title: Mutations::CheckInBook
depends_on: TASK-003
attempts: 1
max_attempts: 3
description: |
  Same shape as TASK-005 but for check_in!, mirroring the REST
  check_in action's "that book isn't checked out" case.
acceptance: |
  - Mutations::CheckInBook exists and is exposed on MutationType
  - Tests cover a successful check-in and check-in of a book that
    isn't checked out (returns success: false, not a crash)
  - bin/rails db:test:prepare test passes
notes:

## TASK-007
status: in_progress
title: Mutations::CreateBook
depends_on: TASK-002, TASK-003
attempts: 1
max_attempts: 3
description: |
  Add app/graphql/mutations/create_book.rb (title: String!, author:
  String!), using TASK-002's validations to return field errors on
  blank input instead of raising.
acceptance: |
  - Mutations::CreateBook exists and is exposed on MutationType
  - Tests cover a successful create and a create with blank
    title/author returning validation errors, not a crash
  - bin/rails db:test:prepare test passes
notes:

## TASK-008
status: pending
title: Mutations::UpdateBook
depends_on: TASK-002, TASK-003
attempts: 0
max_attempts: 3
description: |
  Add app/graphql/mutations/update_book.rb (id: ID!, title: String,
  author: String) for partial updates, reusing TASK-002's validations
  for error responses.
acceptance: |
  - Mutations::UpdateBook exists and is exposed on MutationType
  - Tests cover a successful partial update and an update with
    invalid data returning validation errors
  - bin/rails db:test:prepare test passes
notes:

## TASK-009
status: pending
title: Malformed query error handling
depends_on: TASK-004
attempts: 0
max_attempts: 3
description: |
  Add a request test that POSTs a syntactically invalid GraphQL query
  to /graphql and asserts a well-formed GraphQL-shaped error JSON
  response (an "errors" key), not a 500. Fix GraphqlController if
  needed to rescue and format this properly.
acceptance: |
  - A test covers a malformed query
  - The response has a GraphQL "errors" array, not an unhandled 500
  - bin/rails db:test:prepare test passes
notes:

## TASK-010
status: pending
title: README documentation for GraphQL API
depends_on: TASK-005, TASK-006, TASK-007, TASK-008
attempts: 0
max_attempts: 3
description: |
  Update README.md with a "GraphQL API" section: the /graphql
  endpoint, example books/book queries, and example
  checkOutBook/checkInBook/createBook/updateBook mutations with
  sample variables.
acceptance: |
  - README.md has a GraphQL section with at least one example query
    and one example mutation
  - bin/rails db:test:prepare test passes (confirms nothing broke)
notes:

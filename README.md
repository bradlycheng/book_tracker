# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## GraphQL API

In addition to the REST `BooksController`, this app exposes a GraphQL API at `POST /graphql` (via the `graphql` gem). In development, an interactive GraphiQL explorer is also mounted.

### Queries

List all books, ordered by title:

```graphql
{
  books {
    id
    title
    author
    checkedOut
  }
}
```

Fetch a single book by id:

```graphql
{
  book(id: "1") {
    title
    author
    checkedOut
  }
}
```

### Mutations

Check a book out / back in:

```graphql
mutation {
  checkOutBook(input: { id: "1" }) {
    book { checkedOut }
    success
    errors
  }
}

mutation {
  checkInBook(input: { id: "1" }) {
    book { checkedOut }
    success
    errors
  }
}
```

Create a book:

```graphql
mutation {
  createBook(input: { title: "New Book", author: "Some Author" }) {
    book { id title author checkedOut }
    success
    errors
  }
}
```

Partially update a book:

```graphql
mutation {
  updateBook(input: { id: "1", title: "New Title" }) {
    book { id title author }
    success
    errors
  }
}
```

Every mutation returns `book`, `success`, and `errors` — validation/business-rule failures (e.g. checking out an already-checked-out book, or a blank title) come back as `success: false` with a human-readable `errors` array rather than a hard GraphQL error.

### Trying it with curl

```sh
curl -X POST -H "Content-Type: application/json" \
  -d '{"query":"{ books { title author checkedOut } }"}' \
  http://localhost:3000/graphql
```

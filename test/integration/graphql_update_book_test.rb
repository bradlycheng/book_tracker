require "test_helper"

class GraphqlUpdateBookTest < ActionDispatch::IntegrationTest
  MUTATION = <<~GQL
    mutation($id: ID!, $title: String) {
      updateBook(input: { id: $id, title: $title }) {
        book { id title author }
        success
        errors
      }
    }
  GQL

  test "partially updates a book's title, leaving author untouched" do
    book = books(:one)
    original_author = book.author

    post "/graphql", params: { query: MUTATION, variables: { id: book.id, title: "Updated Title" } }, as: :json
    json = JSON.parse(response.body)["data"]["updateBook"]

    assert json["success"]
    assert_equal "Updated Title", json["book"]["title"]
    assert_equal original_author, json["book"]["author"]
    assert_equal "Updated Title", book.reload.title
  end

  test "returns validation errors for a blank title" do
    book = books(:one)

    post "/graphql", params: { query: MUTATION, variables: { id: book.id, title: "" } }, as: :json
    json = JSON.parse(response.body)["data"]["updateBook"]

    assert_not json["success"]
    assert_includes json["errors"], "Title can't be blank"
  end
end

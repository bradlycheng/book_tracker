require "test_helper"

class GraphqlCreateBookTest < ActionDispatch::IntegrationTest
  MUTATION = <<~GQL
    mutation($title: String!, $author: String!) {
      createBook(input: { title: $title, author: $author }) {
        book { id title author checkedOut }
        success
        errors
      }
    }
  GQL

  test "creates a book with valid attributes" do
    assert_difference "Book.count", 1 do
      post "/graphql", params: { query: MUTATION, variables: { title: "New Book", author: "Some Author" } }, as: :json
    end
    json = JSON.parse(response.body)["data"]["createBook"]

    assert json["success"]
    assert_empty json["errors"]
    assert_equal "New Book", json["book"]["title"]
    assert_not json["book"]["checkedOut"]
  end

  test "returns validation errors for blank title" do
    assert_no_difference "Book.count" do
      post "/graphql", params: { query: MUTATION, variables: { title: "", author: "Some Author" } }, as: :json
    end
    json = JSON.parse(response.body)["data"]["createBook"]

    assert_not json["success"]
    assert_includes json["errors"], "Title can't be blank"
    assert_nil json["book"]
  end
end

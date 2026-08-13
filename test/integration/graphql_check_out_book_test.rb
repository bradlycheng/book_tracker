require "test_helper"

class GraphqlCheckOutBookTest < ActionDispatch::IntegrationTest
  MUTATION = <<~GQL
    mutation($id: ID!) {
      checkOutBook(input: { id: $id }) {
        book { checkedOut }
        success
        errors
      }
    }
  GQL

  test "checks out an available book" do
    book = books(:one)
    assert_not book.checked_out?

    post "/graphql", params: { query: MUTATION, variables: { id: book.id } }, as: :json
    json = JSON.parse(response.body)["data"]["checkOutBook"]

    assert json["success"]
    assert_empty json["errors"]
    assert json["book"]["checkedOut"]
    assert book.reload.checked_out?
  end

  test "returns success: false for an already checked out book" do
    book = books(:one)
    book.check_out!

    post "/graphql", params: { query: MUTATION, variables: { id: book.id } }, as: :json
    json = JSON.parse(response.body)["data"]["checkOutBook"]

    assert_not json["success"]
    assert_includes json["errors"], "Already checked out"
  end
  test "returns success: false with an error for a nonexistent book id" do
    post "/graphql", params: { query: MUTATION, variables: { id: "999999" } }, as: :json
    json = JSON.parse(response.body)["data"]["checkOutBook"]

    assert_not json["success"]
    assert_includes json["errors"], "Book not found"
    assert_nil json["book"]
  end
end

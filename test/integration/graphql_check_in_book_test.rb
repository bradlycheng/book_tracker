require "test_helper"

class GraphqlCheckInBookTest < ActionDispatch::IntegrationTest
  MUTATION = <<~GQL
    mutation($id: ID!) {
      checkInBook(input: { id: $id }) {
        book { checkedOut }
        success
        errors
      }
    }
  GQL

  test "checks in a checked out book" do
    book = books(:one)
    book.check_out!

    post "/graphql", params: { query: MUTATION, variables: { id: book.id } }, as: :json
    json = JSON.parse(response.body)["data"]["checkInBook"]

    assert json["success"]
    assert_empty json["errors"]
    assert_not json["book"]["checkedOut"]
    assert_not book.reload.checked_out?
  end

  test "returns success: false for a book that isn't checked out" do
    book = books(:one)
    assert_not book.checked_out?

    post "/graphql", params: { query: MUTATION, variables: { id: book.id } }, as: :json
    json = JSON.parse(response.body)["data"]["checkInBook"]

    assert_not json["success"]
    assert_includes json["errors"], "That book isn't checked out"
  end
  test "returns success: false with an error for a nonexistent book id" do
    post "/graphql", params: { query: MUTATION, variables: { id: "999999" } }, as: :json
    json = JSON.parse(response.body)["data"]["checkInBook"]

    assert_not json["success"]
    assert_includes json["errors"], "Book not found"
    assert_nil json["book"]
  end
end

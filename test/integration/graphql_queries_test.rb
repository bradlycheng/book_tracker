require "test_helper"

class GraphqlQueriesTest < ActionDispatch::IntegrationTest
  test "books query returns all books ordered by title" do
    post "/graphql", params: { query: "{ books { title author checkedOut } }" }, as: :json
    json = JSON.parse(response.body)
    titles = json["data"]["books"].map { |b| b["title"] }
    assert_equal Book.order(:title).pluck(:title), titles
  end

  test "book query returns a single book by id" do
    book = books(:one)
    post "/graphql", params: { query: "{ book(id: \"#{book.id}\") { id title author } }" }, as: :json
    json = JSON.parse(response.body)
    assert_equal book.title, json["data"]["book"]["title"]
  end

  test "book query returns null for a missing id" do
    post "/graphql", params: { query: "{ book(id: \"999999\") { id } }" }, as: :json
    json = JSON.parse(response.body)
    assert_nil json["data"]["book"]
  end
  test "book query exposes checkout history, most recent first" do
    book = books(:one)
    book.check_out!
    book.check_in!
    book.check_out!

    post "/graphql", params: { query: "{ book(id: \"#{book.id}\") { checkedOut checkouts { returnedAt } } }" }, as: :json
    json = JSON.parse(response.body)["data"]["book"]
    checkouts = json["checkouts"]

    assert json["checkedOut"]
    assert_equal 2, checkouts.length
    assert_nil checkouts.first["returnedAt"], "most recent checkout is still open"
    assert_not_nil checkouts.last["returnedAt"]
  end
end

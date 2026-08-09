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
end

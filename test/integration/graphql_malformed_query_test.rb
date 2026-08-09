require "test_helper"

class GraphqlMalformedQueryTest < ActionDispatch::IntegrationTest
  test "a syntactically invalid query returns a GraphQL-shaped error, not a 500" do
    post "/graphql", params: { query: "{ books { titl" }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert json.key?("errors")
    assert json["errors"].is_a?(Array)
    assert json["errors"].first.key?("message")
  end

  test "a query referencing an unknown field returns a GraphQL-shaped error, not a 500" do
    post "/graphql", params: { query: "{ books { nonexistentField } }" }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert json.key?("errors")
    assert json["errors"].is_a?(Array)
  end
end

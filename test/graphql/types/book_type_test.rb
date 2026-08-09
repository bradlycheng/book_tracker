require "test_helper"

class Types::BookTypeTest < ActiveSupport::TestCase
  test "exposes id, title, author, checkedOut fields" do
    field_names = Types::BookType.fields.keys
    assert_includes field_names, "id"
    assert_includes field_names, "title"
    assert_includes field_names, "author"
    assert_includes field_names, "checkedOut"
  end
end

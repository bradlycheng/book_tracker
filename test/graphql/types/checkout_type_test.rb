require "test_helper"

class Types::CheckoutTypeTest < ActiveSupport::TestCase
  test "exposes checkedOutAt, dueDate, returnedAt fields" do
    field_names = Types::CheckoutType.fields.keys
    assert_includes field_names, "checkedOutAt"
    assert_includes field_names, "dueDate"
    assert_includes field_names, "returnedAt"
  end
end

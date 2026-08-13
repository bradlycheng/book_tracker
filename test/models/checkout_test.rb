require "test_helper"

class CheckoutTest < ActiveSupport::TestCase
  test "invalid without checked_out_at" do
    checkout = Checkout.new(book: books(:one))
    assert_not checkout.valid?
    assert_includes checkout.errors[:checked_out_at], "can't be blank"
  end

  test "a second open checkout for the same book violates the database's unique index" do
    book = books(:one)
    Checkout.create!(book: book, checked_out_at: Time.current)

    assert_raises(ActiveRecord::RecordNotUnique) do
      Checkout.create!(book: book, checked_out_at: Time.current)
    end
  end

  test "a new open checkout is fine once the prior one is returned" do
    book = books(:one)
    first = Checkout.create!(book: book, checked_out_at: Time.current)
    first.update!(returned_at: Time.current)

    second = Checkout.create!(book: book, checked_out_at: Time.current)
    assert second.persisted?
  end

  test "open scope returns only unreturned checkouts" do
    book = books(:one)
    returned = Checkout.create!(book: book, checked_out_at: 1.day.ago, returned_at: Time.current)
    open = Checkout.create!(book: books(:two), checked_out_at: Time.current)

    assert_includes Checkout.open, open
    assert_not_includes Checkout.open, returned
  end
end

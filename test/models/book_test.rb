require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "new book defaults to available" do
    book = Book.create!(title: "Test", author: "Author")
    assert_not book.checked_out?
  end

  test "book can be checked out" do
    book = Book.create!(title: "Test", author: "Author")
    book.update!(checked_out: true)
    assert book.reload.checked_out?
  end

  test "book can be returned" do
    book = Book.create!(title: "Test", author: "Author", checked_out: true)
    book.update!(checked_out: false)
    assert_not book.reload.checked_out?
  end
end
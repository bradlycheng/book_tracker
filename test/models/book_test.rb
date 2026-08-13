require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "new book defaults to available" do
    book = Book.create!(title: "Test", author: "Author")
    assert_not book.checked_out?
  end

  test "check_out! succeeds on an available book" do
    book = Book.create!(title: "Test", author: "Author")
    assert book.check_out!
    assert book.reload.checked_out?
  end

  test "check_out! fails on an already checked out book" do
    book = Book.create!(title: "Test", author: "Author")
    book.check_out!
    assert_not book.check_out!
    assert book.reload.checked_out?
  end

  test "check_in! succeeds on a checked out book" do
    book = Book.create!(title: "Test", author: "Author")
    book.check_out!
    assert book.check_in!
    assert_not book.reload.checked_out?
  end

  test "check_in! fails on an available book" do
    book = Book.create!(title: "Test", author: "Author")
    assert_not book.check_in!
  end

  test "checking a book back in preserves its checkout as history instead of deleting it" do
    book = Book.create!(title: "Test", author: "Author")
    book.check_out!
    book.check_in!

    assert_equal 1, book.checkouts.count
    assert_not_nil book.checkouts.first.returned_at
  end

  test "due_date tracks the current open checkout, and clears once returned" do
    book = Book.create!(title: "Test", author: "Author")
    assert_nil book.due_date

    book.check_out!
    assert_equal 2.weeks.from_now.to_date, book.reload.due_date

    book.check_in!
    assert_nil book.reload.due_date
  end
end

class BookValidationTest < ActiveSupport::TestCase
  test "invalid without a title" do
    book = Book.new(author: "Author")
    assert_not book.valid?
    assert_includes book.errors[:title], "can't be blank"
  end

  test "invalid without an author" do
    book = Book.new(title: "Title")
    assert_not book.valid?
    assert_includes book.errors[:author], "can't be blank"
  end
end

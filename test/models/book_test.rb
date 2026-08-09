# require "test_helper"

# class BookTest < ActiveSupport::TestCase
#   test "new book defaults to available" do
#     book = Book.create!(title: "Test", author: "Author")
#     assert_not book.checked_out?
#   end

#   test "book can be checked out" do
#     book = Book.create!(title: "Test", author: "Author")
#     book.update!(checked_out: true)
#     assert book.reload.checked_out?
#   end

#   test "book can be returned" do
#     book = Book.create!(title: "Test", author: "Author", checked_out: true)
#     book.update!(checked_out: false)
#     assert_not book.reload.checked_out?
#   end
# end
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
    book = Book.create!(title: "Test", author: "Author", checked_out: true)
    assert_not book.check_out!
    assert book.reload.checked_out?
  end

  test "check_in! succeeds on a checked out book" do
    book = Book.create!(title: "Test", author: "Author", checked_out: true)
    assert book.check_in!
    assert_not book.reload.checked_out?
  end

  test "check_in! fails on an available book" do
    book = Book.create!(title: "Test", author: "Author")
    assert_not book.check_in!
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

require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "index lists books" do
    Book.create!(title: "Refactoring", author: "Fowler")
    get books_path
    assert_response :success
    assert_select "td", text: "Refactoring"
  end

  test "checking out an available book marks it checked out" do
    book = Book.create!(title: "Test", author: "Author")
    patch check_out_book_path(book)
    assert book.reload.checked_out?
  end

  test "checking out an already checked out book does not succeed" do
    book = Book.create!(title: "Test", author: "Author")
    book.check_out!
    patch check_out_book_path(book)
    assert_redirected_to books_path
    assert_equal "Already checked out.", flash[:alert]
  end

  test "returning a checked out book makes it available" do
    book = Book.create!(title: "Test", author: "Author")
    book.check_out!
    patch check_in_book_path(book)
    assert_not book.reload.checked_out?
  end
end

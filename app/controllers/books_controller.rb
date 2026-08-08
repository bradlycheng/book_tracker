class BooksController < ApplicationController
  def index
    @books = Book.order(:title)
  end

  def check_out
    @book = Book.find(params[:id])

    if @book.checked_out?
      redirect_to books_path, alert: "Already checked out."
    else
      @book.update!(checked_out: true)
      redirect_to books_path, notice: "Checked out."
    end
  end

  def check_in
    @book = Book.find(params[:id])

    if @book.checked_out?
      @book.update!(checked_out: false)
      redirect_to books_path, notice: "Returned."
    else
      redirect_to books_path, alert: "That book isn't checked out."
    end
  end
end

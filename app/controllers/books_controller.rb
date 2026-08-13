class BooksController < ApplicationController
  def index
    @books = Book.includes(:open_checkout).order(:title)
  end

  def check_out
    @book = Book.find(params[:id])

    if @book.check_out!
      redirect_to books_path, notice: "Checked out."
    else
      redirect_to books_path, alert: "Already checked out."
    end
  end

  def check_in
    @book = Book.find(params[:id])

    if @book.check_in!
      redirect_to books_path, notice: "Returned."
    else
      redirect_to books_path, alert: "That book isn't checked out."
    end
  end
end

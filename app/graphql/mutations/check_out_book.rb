# frozen_string_literal: true

module Mutations
  class CheckOutBook < BaseMutation
    argument :id, ID, required: true

    field :book, Types::BookType, null: true
    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      book = Book.find_by(id: id)
      return { book: nil, success: false, errors: ["Book not found"] } unless book

      if book.check_out!
        { book: book, success: true, errors: [] }
      else
        { book: book, success: false, errors: ["Already checked out"] }
      end
    end
  end
end

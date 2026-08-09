# frozen_string_literal: true

module Mutations
  class CreateBook < BaseMutation
    argument :title, String, required: true
    argument :author, String, required: true

    field :book, Types::BookType, null: true
    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(title:, author:)
      book = Book.new(title: title, author: author)
      if book.save
        { book: book, success: true, errors: [] }
      else
        { book: nil, success: false, errors: book.errors.full_messages }
      end
    end
  end
end

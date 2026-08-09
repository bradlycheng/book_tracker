# frozen_string_literal: true

module Mutations
  class UpdateBook < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :author, String, required: false

    field :book, Types::BookType, null: true
    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:, title: nil, author: nil)
      book = Book.find_by(id: id)
      return { book: nil, success: false, errors: ["Book not found"] } unless book

      attrs = {}
      attrs[:title] = title unless title.nil?
      attrs[:author] = author unless author.nil?

      if book.update(attrs)
        { book: book, success: true, errors: [] }
      else
        { book: book, success: false, errors: book.errors.full_messages }
      end
    end
  end
end

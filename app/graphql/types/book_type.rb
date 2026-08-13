# frozen_string_literal: true

module Types
  class BookType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :author, String, null: false
    field :checked_out, Boolean, null: false, method: :checked_out?
    field :due_date, GraphQL::Types::ISO8601Date, null: true
    field :checkouts, [Types::CheckoutType], null: false,
      description: "Full checkout history for this book, most recent first."
  end
end

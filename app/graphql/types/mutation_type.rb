# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :check_out_book, mutation: Mutations::CheckOutBook
  end
end

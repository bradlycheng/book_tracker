# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :check_out_book, mutation: Mutations::CheckOutBook
    field :check_in_book, mutation: Mutations::CheckInBook
    field :create_book, mutation: Mutations::CreateBook
    field :update_book, mutation: Mutations::UpdateBook
  end
end

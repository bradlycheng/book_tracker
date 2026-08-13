# frozen_string_literal: true

module Types
  class CheckoutType < Types::BaseObject
    field :id, ID, null: false
    field :checked_out_at, GraphQL::Types::ISO8601DateTime, null: false
    field :due_date, GraphQL::Types::ISO8601Date, null: true
    field :returned_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end

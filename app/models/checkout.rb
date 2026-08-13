class Checkout < ApplicationRecord
  belongs_to :book

  validates :checked_out_at, presence: true

  scope :open, -> { where(returned_at: nil) }
  scope :returned, -> { where.not(returned_at: nil) }

  def open?
    returned_at.nil?
  end
end

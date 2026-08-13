class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true

  has_many :checkouts, -> { order(checked_out_at: :desc) }, dependent: :destroy
  has_one :open_checkout, -> { where(returned_at: nil) }, class_name: "Checkout"

  # Returns true if this call performed the checkout, false if the book was
  # already checked out. There's no in-app locking here on purpose: the
  # partial unique index on checkouts(book_id) WHERE returned_at IS NULL
  # rejects a second concurrent open checkout for the same book at the
  # database level, so the classic check-then-write race is structurally
  # impossible rather than something this method has to guard against.
  # See test/models/book_race_test.rb.
  def check_out!
    checkouts.create!(checked_out_at: Time.current, due_date: 2.weeks.from_now.to_date)
    reset_open_checkout
    true
  rescue ActiveRecord::RecordNotUnique
    false
  end

  def check_in!
    updated = checkouts.open.update_all(returned_at: Time.current)
    reset_open_checkout if updated > 0
    updated > 0
  end

  def checked_out?
    open_checkout.present?
  end

  def due_date
    open_checkout&.due_date
  end

  private

  def reset_open_checkout
    association(:open_checkout).reset
  end
end

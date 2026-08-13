class BackfillCheckoutsFromBooks < ActiveRecord::Migration[8.1]
  # Scoped to this migration on purpose, instead of referencing the real
  # Book/Checkout models, so this keeps working the same way even after
  # those classes change shape in the future.
  class MigrationBook < ActiveRecord::Base
    self.table_name = "books"
  end

  class MigrationCheckout < ActiveRecord::Base
    self.table_name = "checkouts"
  end

  def up
    MigrationBook.where(checked_out: true).find_each do |book|
      MigrationCheckout.create!(
        book_id: book.id,
        checked_out_at: book.updated_at || Time.current,
        due_date: book.due_date
      )
    end
  end

  def down
    # No-op: dropping the checkouts table in CreateCheckouts' down already
    # removes this data.
  end
end

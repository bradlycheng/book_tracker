class CreateCheckouts < ActiveRecord::Migration[8.1]
  def change
    create_table :checkouts do |t|
      t.references :book, null: false, foreign_key: true
      t.datetime :checked_out_at, null: false
      t.date :due_date
      t.datetime :returned_at

      t.timestamps
    end

    # This is the enforcement mechanism: at most one open (returned_at IS
    # NULL) checkout per book, guaranteed by the database itself. A second
    # concurrent INSERT for the same book while one is already open raises
    # ActiveRecord::RecordNotUnique instead of racing on a read-then-write.
    add_index :checkouts, :book_id, unique: true, where: "returned_at IS NULL",
      name: "index_checkouts_on_book_id_when_open"
  end
end

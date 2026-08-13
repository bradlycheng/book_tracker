class RemoveCheckedOutAndDueDateFromBooks < ActiveRecord::Migration[8.1]
  def change
    remove_column :books, :checked_out, :boolean, default: false, null: false
    remove_column :books, :due_date, :date
  end
end

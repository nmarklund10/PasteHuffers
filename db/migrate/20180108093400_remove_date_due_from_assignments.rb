class RemoveDateDueFromAssignments < ActiveRecord::Migration
  def change
    remove_column :assignments, :date_due, :string
  end
end

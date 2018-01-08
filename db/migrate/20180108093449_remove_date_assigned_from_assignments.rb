class RemoveDateAssignedFromAssignments < ActiveRecord::Migration
  def change
    remove_column :assignments, :date_assigned, :string
  end
end

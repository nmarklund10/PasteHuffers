class AddSkeletonToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :skeleton, :text
  end
end

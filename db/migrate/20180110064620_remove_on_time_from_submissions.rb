class RemoveOnTimeFromSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :on_time, :boolean
  end
end

class RemoveDateSubmittedFromSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :date_submitted, :datetime
  end
end

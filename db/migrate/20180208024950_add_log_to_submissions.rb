class AddLogToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :log, :text
  end
end

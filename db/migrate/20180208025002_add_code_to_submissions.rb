class AddCodeToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :code, :text
  end
end

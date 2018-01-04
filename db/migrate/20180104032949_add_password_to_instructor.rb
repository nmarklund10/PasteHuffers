class AddPasswordToInstructor < ActiveRecord::Migration
  def change
    add_column :instructors, :password, :string
  end
end

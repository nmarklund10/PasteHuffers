class CreateAcceptedInstructors < ActiveRecord::Migration
  def change
    create_table :accepted_instructors do |t|
      t.string :email

      t.timestamps null: false
    end
  end
end

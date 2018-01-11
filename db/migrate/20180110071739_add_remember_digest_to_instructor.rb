class AddRememberDigestToInstructor < ActiveRecord::Migration
  def change
    add_column :instructors, :remember_digest, :string
  end
end

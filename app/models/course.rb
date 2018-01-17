class Course < ActiveRecord::Base
  belongs_to :instructor
  has_many :assignments, dependent: :destroy

  def destroy
    #Destroy all the related files
    super
  end
end

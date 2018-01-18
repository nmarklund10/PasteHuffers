require_relative '../../fileIO/fileIO'
class Course < ActiveRecord::Base
  belongs_to :instructor
  has_many :assignments, dependent: :destroy

  def destroy
    #Destroy all the related files
    begin
      FileIO.delete_course(@instructor_id,@id)
    rescue
      #Do not care if file DNE, if file DNE then it is already deleted
    end
    super
  end
end

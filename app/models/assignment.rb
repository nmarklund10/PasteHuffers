require_relative '../../fileIO/fileIO'
class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :submissions, dependent: :destroy

  def destroy
    #Destroy all the related files
    begin
      cuid = @course_id
      iuid = Course.find(cuid).instructor_id
      FileIO.delete_assignment(iuid,cuid,@id)
    rescue
      #Do not care if file DNE, if file DNE then file already deleted
    end
    super
  end
end

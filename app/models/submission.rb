require_relative '../../fileIO/fileIO'
class Submission < ActiveRecord::Base
  belongs_to :assignment
  
  def destroy
    #Destroy all the related files
    begin
      auid = @assignment_id
      assign = Assignment.find(auid)
      language = assign.language
      cuid = assign.course_id
      iuid = Course.find(cuid).instructor_id
      FileIO.delete_submission(iuid,cuid,auid,@student_id,language)
    rescue
      #Do not care if file DNE
    end
    super
  end
end

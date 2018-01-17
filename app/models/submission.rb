class Submission < ActiveRecord::Base
  belongs_to :assignment
  
  def destroy
    #Destroy all the related files
    super
  end
end

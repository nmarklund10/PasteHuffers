class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :submissions, dependent: :destroy

  def destroy
    #Destroy all the related files
    super
  end
end

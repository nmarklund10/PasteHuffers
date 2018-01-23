class InstructorsController < ApplicationController
  def createInstructorForm
    render "createInstructorForm"
  end
  def createNewInstructor
    instr = Instructor.create(name: params[:name], email: params[:email], password: "")
    render json: {"success" => true}
  end
end

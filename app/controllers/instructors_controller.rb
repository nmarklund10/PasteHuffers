class InstructorsController < ApplicationController
  def createInstructorForm
    render "createInstructorForm"
  end
  def createNewInstructor
    instr = Instructor.create(name: params[:name], email: params[:email], password: "")
    session["IUID"] = instr.id
    render json: {"success" => true}
  end
end

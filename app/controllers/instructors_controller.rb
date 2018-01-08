class InstructorsController < ApplicationController
  def createInstructorForm
    render "createInstructorForm"
  end
  def createNewInstructor
    if params[:name] == nil or params[:email] == nil or params[:password] == nil then
      render json: {"success" => false, "reason" => "Insufficient Data Provided!"}
      return
    end
    if Instructor.where(name: params[:name]).length != 0 then
      render json: {"success" => false, "reason" => "Instructor with that name already exists!"}
      return
    end
    instr = Instructor.create(name: params[:name], email: params[:email], password: params[:password])
    render json: {"success" => true}
  end
end

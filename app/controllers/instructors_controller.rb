class InstructorsController < ApplicationController
  def new
      @new_instructor = Instructor.new
  end

  def create
  end
end

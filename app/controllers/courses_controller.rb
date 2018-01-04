class CoursesController < ApplicationController
  def new
  	@new_course = Course.new
  end

  def create
  	redirect_to courses_path
  end

  def index
  end
end

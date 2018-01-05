class CDashController < ApplicationController
    #List all in database
    def index
    end
    
    def getClasses
        iuid = session["IUID"]
        if iuid == nil then render json: [] end
        @courses = Course.where('instructor_id = ?',iuid)
        render json: @courses
    end
    
    def createCourseForm
        render "createCourseForm"
    end

    def createNewCourse
        if session["IUID"] == nil then render json: {"success" => false, "reason" => "No User Logged in"} end
        if params["name"] == nil then render json: {"success" => false, "reason" => "Need a name"} end
        course = Course.create(instructor_id: session["IUID"], name:params["name"])
        render json: {"success" => true, "course" => course}
    end
end

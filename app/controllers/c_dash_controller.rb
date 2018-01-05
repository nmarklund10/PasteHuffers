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
end

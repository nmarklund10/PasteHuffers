class CeController < ApplicationController
    #List all in database
    def index
        render "code_editor"
    end
    
    #New object. Called when asking for input
    def getSkeletonCode
        currentAssignment = Assignment.find(params["AUID"])
        currentCourse = Course.find(currentAssignment.course_id)
        currentInstructor = Instructor.find(currentCourse.instructor_id)
        code = get_skeleton_code(currentCourse.instructor_id, currentAssignment.course_id, params["AUID"])
        render json: {"success" => true, "code" => code}
    end
    
    #Creates a record in database
    def create
    end
    
    #Updates record in database
    def update
    end
    
    #CAREFUL! Will not be used for some
    def delete
    end
    
    #Displays one element
    def show
    end
end

class CeController < ApplicationController
    #List all in database
    def index
        render "code_editor"
    end
    
    #New object. Called when asking for input
    def getSkeletonCode
        auid = params["AUID"]
        if session["IUID"] == nil then 
            render json: {"success" => false, "reason" => "No User Logged in"} 
            return 
        end
        if auid == nil then 
            render json: {"success" => false, "reason" => "Need an AUID"} 
            return 
        end
        currentAssignment = Assignment.find(auid)
        if (currentAssignment.length == 0)
            render json: {"success" => false, "reason" => "Assignment with #{auid} does not exist!"}
            return
        end
        currentCourse = Course.find(currentAssignment.course_id)
        if (currentCourse.length == 0)
            render json: {"success" => false, "reason" => "Course with #{currentAssignment.course_id} does not exist!"}
            return
        end
        currentInstructor = Instructor.find(currentCourse.instructor_id)
        if (currentInstructor.length == 0)
            render json: {"success" => false, "reason" => "Course with #{currentInstructor.instructor_id} does not exist!"}
            return
        end
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

require_relative "../../code_checker/code_checker"
class CeController < ApplicationController
    #List all in database
    def index
        render "code_editor"
    end
    
    #New object. Called when asking for input
    def getSkeletonCode
        auid = params["AUID"]
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
    
    def testCode
        begin
            if session["AUID"] == nil or session["SUID"] == nil then
                raise "AUID or SUID was not in session"
            end
            if params["code"] == nil then
                raise "No code given"
            end
            output = CodeChecker.testCode(Assignment.find(session["AUID"]).language, session["SUID"],params["code"])
            render json: {"success" => true, "output" => output}
        rescue Exception => e
            puts e
            render json: {"success" => false, "reason" => "Invalid code test request"}
        end
    end
end

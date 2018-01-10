class ADashController < ApplicationController
    def index
        #Ensure that there is a user signed in
        if session["IUID"] == nil then
            render json: {"success" => false, "reason" => "No user is currently logged in."}
            return
        end
        #Ensure that we are given an AUID
        if params["id"] == nil then
            render json: {"success" => false, "reason" => "Did not supply a AUID"}
            return
        end
        #Ensure the given AUID belongs to the logged in professor
        #IF the given AUID does not exist then rails will raise 404/500
        begin
            assignmentObject = Assignment.find(params["id"])
            courseObject = Course.find(assignmentObject.course_id)
            if courseObject.instructor_id != session["IUID"] then
                raise "Instructor does not have access to this assignment"
            end
        rescue
            render json: {"success" => false, "reason" => "AUID is invalid", "assignObject" => assignmentObject, "courseObject" => courseObject, "iuid" => session["IUID"] }
            return
        end
        @auid = params["id"]
        render "assignmentDashboard"
    end
end
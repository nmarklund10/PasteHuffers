class AssignmentsController < ApplicationController
    

    def getAssignments
        cuid = params[:id]
        if cuid == nil then 
                render json: "" 
                return 
        end
        @assignments = Assignment.where("course_id = ?", cuid)
        render json: {"assignments" => @assignments, "course" => Course.find(cuid)} 
    end

    def createAssignmentForm
        render "createAssignmentForm"
    end
end

class AssignmentsController < ApplicationController
    

    def getAssignments
        cuid = params[:id]
        if cuid == nil then 
                render json: {"success" => false}
                return 
        end
        @assignments = Assignment.where("course_id = ?", cuid)
        render json: {"assignments" => @assignments, "course" => Course.find(cuid)} 
    end

    def createAssignmentForm
        render "createAssignmentForm"
    end
    
    def createNewAssignment
        if params[:name] == nil || params[:language] == nil || params[:CUID] == nil then
            render json: {"success" => false, "reason" => "Not all necessary parameters given to server!"}
            return
        end
        if Assignment.where(name: params[:name], course_id: params[:CUID]) != [] then
            render json: {"success" => false, "reason" => "Assignment by the given name already exists in this class!"}
            return
        end
        
        @assignment = Assignment.create(name: params[:name], language: params[:language], course_id:params[:CUID])
        session[:auid] = @assignment.id
        render json: {"success" => true, "assignment" => @assignment}
    end
    
    def deleteAssignment
        if session["IUID"] == nil then
            render json: {"success" => false, "reason" => "No User Logged in"}
            return
        end
        if params["id"] == nil then
            render json: {"success" => false, "reason" => "Invalid delete request"}
            return
        end
        begin
            assignment = Assignment.find(params["id"])
            if Course.find(assignment.course_id).instructor_id != session["IUID"] then
                raise "Requesting Professor does not have ownership of course"
            end
            assignment.destroy
            
            render json: {"success" => true}
            return
        rescue
            render json: {"success" => false, "reason" => "Invalid delete request"}
            return
        end
    end
    
end

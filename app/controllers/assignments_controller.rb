class AssignmentsController < ApplicationController
    #Is called on /assignments/new
    def new
        if params[:IuiD] != nil then
            @IuiD = params[:IuiD]
        end
        if params[:CuiD] != nil then
            @CuiD = params[:CuiD]
        end
        @IuiD = 109
        @CuiD = 120
        @assignment = Assignment.new 
    end

    def getAssignments
        cuid = params[:id]
        if cuid == nil then 
                render json: "" 
                return 
        end
        @assignments = Assignment.where("course_id = ?", cuid)
        render json: {"assignments" => @assignments, "course" => Course.find(cuid)} 
    end

    def create
    end
end

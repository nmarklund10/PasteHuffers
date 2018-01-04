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

    def create
    end
end

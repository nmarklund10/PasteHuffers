class ADashController < ApplicationController
    def viewAssignment
       render "viewAssignments"
    end
    def getSubmitted
        auid = session["auid"]
        if auid == nil then render json: [] end
        @assignments = Assignments.where('assignment_id = ?',auid)
        render json: @assignments
    end
end

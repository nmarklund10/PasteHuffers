class SubmissionsController < ApplicationController
    def viewSubmissions
       render "viewSubmissions"
    end
    def getSubmissions
        auid = params["auid"]
        if auid == nil then render json: [] end
        @submissions = Submission.where("assignment_id = ?", auid)
        render json: {"submissions" => @submissions} 
    end
end

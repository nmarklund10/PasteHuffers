class SubmissionsController < ApplicationController
   
    def getSubmissions
        auid = params["id"]
        if auid == nil then 
            render json: {"success" => false, "reason" => "No assignment id set, navigated to this page incorrectly."} 
            return
        end
        @submissions = Submission.where(assignment_id: auid)
        render json: {"success" => true, "submissions" => @submissions} 
    end
end

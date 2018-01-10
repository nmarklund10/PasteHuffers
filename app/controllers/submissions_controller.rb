class SubmissionsController < ApplicationController
   
    def getSubmissions
        auid = session["auid"]
        if auid == nil then 
            render json: {"success" => false, "reason" => "No assignment id set, navigated to this page incorrectly."} 
        end
        @submissions = Submission.where(assignment_id: auid)
        render json: {"success" => true, "submissions" => @submissions} 
    end
end

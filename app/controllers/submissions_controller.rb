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

    def createSubmission
        auid = session["AUID"]
        if (auid == nil) then
            render json: {"success" => false, "reason" => "No Assignment ID for current assignment."}
        end
        suid = session["SUID"]
        if (suid == nil) then
            render json: {"success" => false, "reason" => "No Student ID found."}
        end
        if (params[:cp] == nil) then
            render json: {"success" => false, "reason" => "No Copy Paste Boolean."}
        end
        begin
            currentAssignment = Assignment.find(auid)
            currentCourse = Course.find(currentAssignment.course_id)
            Submission.create(student_id: suid, assignment_id: auid, paste_detected: params[:cp])
            FileIO.write_submission(currentCourse.instructor_id, currentAssignment.course_id, params["AUID"], suid, params[:submission], currentAssignment.language)
            FileIO.write_log(currentCourse.instructor_id, currentAssignment.course_id, params["AUID"], suid, params[:log])
            render json: {"success" => true }        
        rescue
            render json: {"success" => false, "reason" => "Invalid submission request."}
        end
    end
end

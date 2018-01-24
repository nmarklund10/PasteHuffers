require_relative '../../fileIO/fileIO'

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
            return
        end
        suid = session["SUID"]
        if (suid == nil) then
            render json: {"success" => false, "reason" => "No Student ID found."}
            return
        end
        if (params[:cp] == nil) then
            render json: {"success" => false, "reason" => "No Copy Paste Boolean."}
            return
        end
        begin
            currentAssignment = Assignment.find(auid)
            currentCourse = Course.find(currentAssignment.course_id)
            Submission.create(student_id: suid, assignment_id: auid, paste_detected: params[:cp])
            FileIO.write_submission(currentCourse.instructor_id, currentAssignment.course_id, auid, suid, params[:submission], currentAssignment.language)
            FileIO.write_log(currentCourse.instructor_id, currentAssignment.course_id, auid, suid, params[:log])
            render json: {"success" => true }        
        rescue Exception => e
            puts e
            render json: {"success" => false, "reason" => "Invalid submission request."}
        end
    end

    def downloadLog
        begin
            if session["IUID"] == nil then
                raise "No user logged in"
            end
            if params["submissionId"] == nil then
                raise "Not enough information given"
            end
            auid = Submission.find(params["submissionId"]).assignment_id
            suid = Submission.find(params["submissionId"]).student_id
            cuid = Assignment.find(auid).course_id
            if Course.find(cuid).instructor_id != session["IUID"] then
                raise "User does not have ownership of submission"
            end
            puts FileIO.constructFileName(session["IUID"],cuid,auid,suid,true).to_s
            send_file(FileIO.constructFileName(session["IUID"],cuid,auid,suid,true), filename: suid+"-log.txt",  type: "application/txt")
        rescue Exception => e
            puts e
            render json: {"success" => false, "reason" => "Invalid download request"}
        end
    end

    def downloadSubmission
        begin
            if session["IUID"] == nil then
                raise "No user logged in"
            end
            if params["submissionId"] == nil then
                raise "Not enough information given"
            end
            auid = Submission.find(params["submissionId"]).assignment_id
            suid = Submission.find(params["submissionId"]).student_id
            cuid = Assignment.find(auid).course_id
            language = Assignment.find(auid).language
            if Course.find(cuid).instructor_id != session["IUID"] then
                raise "User does not have ownership of submission"
            end
            send_file(FileIO.constructFileName(session["IUID"],cuid,auid,suid,false,language), filename: suid+"-submission"+FileIO.get_file_extension(language),  type: "application/txt")
        rescue Exception => e
            puts e
            render json: {"success" => false, "reason" => "Invalid download request"}
        end
    end

    def massDownloadSubmission
        begin
            if session["IUID"] == nil then
                raise "No user logged in"
            end
            if params["AUID"] == nil then
                raise "Not enough information given"
            end
            cuid = Assignment.find(params["AUID"]).course_id
            if Course.find(cuid).instructor_id != session["IUID"] then
                raise "User does not have ownership of submission"
            end
            send_file(FileIO.generateZipFile(session["IUID"],cuid,params["AUID"]), filename: "all-submissions.zip")
        rescue Exception => e
            puts e
            render json: {"success" => false, "reason" => "Server error"}
        end
    end
end

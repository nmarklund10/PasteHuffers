require_relative '../../fileIO/fileIO'
class IDashController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => :upload
    #List all in database
    def index
        if session["IUID"] == nil then
            render json: {"success" => false, "reason" => "No User signed in"}
            return
        end
        #Check to see if the current instructor is an admin
        if Admin.where(email: Instructor.find(session["IUID"]).email)[0] != nil then
            @isAdmin = true
        else
            @isAdmin = false
        end
        render "dashboard"
    end
    #upload skeleton code
    def upload
        if !(@auid = session[:auid])
            puts "No AUID in session!"
            render json: {"success" => false, "reason" => "No AUID in session!"}
            return
        end
        session.delete(:auid)
        puts session
        if !params[:uploadedFile]
            puts "No file!"
            render json: {"success" => false, "reason" => "No file!"}
            return   
        end
        if !(@iuid = session["IUID"])
            puts "No IUID!"
            render json: {"success" => false, "reason" => "No IUID!"}
            return            
        end
        if !(@assignment = Assignment.find(@auid))
            puts "No assignment with that id!"
            render json: {"success" => false, "reason" => "No assignment with that name!"}
            return
        end         
        if !Course.find(@assignment.course_id)
            puts "No course with that assignment!"
            render json: {"success" => false, "reason" => "No course with that assignment!"}
            return
        end
        @cuid = @assignment.course_id
        file = params[:uploadedFile].read()
        FileIO.write_skeleton_code(@iuid, @cuid, @auid, file, @assignment.language)
        render json: {"success" => true}
    end

    def getWhiteList
        begin
            instructor = Instructor.find(session["IUID"])
            if Admin.where(email: instructor.email)[0] == nil then
                raise "Instructor is not admin"
            end
            render json: AcceptedInstructors.all
        rescue
            render json: {"success" => false, "reason" => "The logged in instructor does not have privelege for this resource"}
            return
        end
    end

    def addToWhiteList
        begin
            instructor = Instructor.find(session["IUID"])
            if Admin.where(email: instructor.email)[0] == nil then
                raise "Instructor is not admin"
            end
            AcceptedInstructors.create(email:params["email"])
            render json: {"success" => true}
            return
        rescue
            render json: {"success" => false, "reason" => "Invalid request"}
            return
        end
    end

    def deleteFromWhiteList
        begin
            instructor = Instructor.find(session["IUID"])
            if Admin.where(email: instructor.email)[0] == nil then
                raise "Instructor is not admin"
            end
            AcceptedInstructors.where(email:params["email"]).destroy_all
            render json: {"success" => true}
            return
        rescue
            render json: {"success" => false, "reason" => "Invalid request"}
            return
        end
    end
end

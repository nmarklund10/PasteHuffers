require_relative '../../fileIO/fileIO.rb'
class IDashController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => :upload
    #List all in database
    def index
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
        FileIO.write_skeleton_code(@iuid, @cuid, @auid, file)
        render json: {"success" => true}
    end
end

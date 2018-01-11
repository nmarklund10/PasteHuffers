require_relative '../../fileIO/fileIO.rb'
class IDashController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => :upload
    #List all in database
    def index
        render "dashboard"
    end
<<<<<<< HEAD
    
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
=======

    #New object. Called when asking for input
    def new
    end

    #Creates a record in database
    def create
    end

    #Updates record in database
    def update
    end

    #CAREFUL! Will not be used for some
    def delete
    end

    #Displays one element
    def show
>>>>>>> 3dc219b9c93c521c3581fb480c5a33b3b1ac439b
    end
end

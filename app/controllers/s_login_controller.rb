require 'net/http'
require 'uri'
require 'json'
require_relative '../../fileIO/fileIO'

class SLoginController < ApplicationController
    #List all in database
    def index
        render "s_login2"
    end
    
    def getAssignmentID
        render "getAssignmentID"
    end
    
    def googleLogIn
        uri = URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=" + params[:id_token])
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        response = https.request(request)
        response = JSON.parse(response.body)
        name = response["name"].gsub(/ /, '_')
        session["SUID"] = response["email"] + "[" + name + "]"
        puts session["SUID"]
        render json: {"success" => true, "name" => name}
    end
    
    def verifyCreds
        #Retrieve POST data
        auid = params["access"]
        #Look for assignments with ID
        currentAssignment = Assignment.find_by_id(auid)
        if (currentAssignment == nil)
           render json: {"success" => false, "reason" => "No Assignment found with that ID!"}
           return
        end
        #check if student already has a submission for this assignment
        currentCourse = Course.find(currentAssignment.course_id)
        cuid = currentAssignment.course_id
        iuid = currentCourse.instructor_id
        if File.file?(FileIO.constructFileName(iuid, cuid, auid, session["SUID"], true))
           render json: {"success" => false, "reason" => "You already have a submission for that assignment!"}
           return 
        end
        #Verified info, save assignment id into session and go to code editor
        session["AUID"] = auid
        render json: {"success" => true}
    end
end

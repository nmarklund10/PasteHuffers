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
<<<<<<< HEAD
        #If we have any list of instr, just grab the first one. Instructor Creation should check unqiuness
        auid = session["AUID"]
        suid = session["SUID"]
        if auid == nil then 
            render json: {"success" => false, "reason" => "No assignment id set, navigated to this page incorrectly."} 
        end
        if suid == nil then 
            render json: {"success" => false, "reason" => "No student id set, navigated to this page incorrectly."} 
        end
        #Verified info, save instructor id into the session then redirect to dashboard
        session["AUID"] = possibleAssignment[0].id
=======
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
>>>>>>> f162b9ce0a5d7c6514d08234bf0b6d344668560f
        render json: {"success" => true}
    end
end

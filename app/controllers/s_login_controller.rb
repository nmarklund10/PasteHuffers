require 'net/http'
require 'uri'
require 'json'
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
        name = response["name"]
        session["SUID"] = response["email"] + "(" + name + ")"
        puts session["SUID"]
        render json: {"success" => true, "name" => name}
    end
    
    def verifyCreds
        #Retrieve POST data
        accessId = params["access"]
        #Look for instructors with matching names in database
        possibleAssignment = Assignment.where( id: accessId)
        if possibleAssignment.length == 0 then
            #Return error if we do not find anybody
            render json: {"success" => false, "reason" => "No assignment found with that Assignment ID."}
            return
        end
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
        render json: {"success" => true}
    end
end

require 'net/http'
require 'uri'
require 'json'
class ILoginController < ApplicationController
    #Shows the instructor login page
    def index
        render "login"
    end
    #Verifies the given credentials
    #If correct then a object telling success is given back and the user is redirected to the dashboard
    def verifyCreds
        uri = URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=" + params[:id_token])
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        response = https.request(request)
        response = JSON.parse(response.body)
        username = response["name"]
        
        #Look for instructors with matching names in database
        possibleInstrs = Instructor.where(name: username)
        instr = possibleInstrs[0]
        if instr == nil then
            instr = Instructor.create(name: response["name"], email: "", password: "")
            if instr == nil then
                render json: {"success" => false, "reaons" => "Could not create account!"}
                return
            end
        end
        #If we have any list of instr, just grab the first one. Instructor Creation should check unqiuness
        #Verified info, save instructor id into the session then redirect to dashboard
        session["IUID"] = instr.id
        render json: {"success" => true, "name" => username}
    end
    def destroy
         #session.delete("IUID")
         #@current_user = nil
         reset_session
         redirect_to root_url
    end
end

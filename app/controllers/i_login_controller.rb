require 'net/http'
require 'uri'
require 'json'
class ILoginController < ApplicationController
    #Shows the instructor login page
    def index
        render "login"
    end
    def log_in(instructor)
        session["IUID"] = instructor.id
    end
    def remember(instr)
        instr.remember
        cookies.permanent.signed["IUID"] = instructor.id
        cookies.permanent[:remember_token] = instructor.remember_token
    end
    # Returns the instructor corresponding to the remember token cookie.
    def current_instr
        if (instructor_id = session["IUID"])
            @current_instructor ||= Instructor.find_by(id: instructor_id)
        elsif (instructor_id = cookies.signed["IUID"])
            instructor = Instructor.find_by(id: instructor_id)
            if instructor && instructor.authenticated?(cookies[:remember_token])
                log_in instructor
                @current_instructor = instructor
            end
        end
    end
  
    #Verifies the given credentials
    #If correct then a object telling success is given back and the instructor is redirected to the dashboard
    def verifyCreds
        uri = URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=" + params[:id_token])
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        response = https.request(request)
        response = JSON.parse(response.body)
        username = response["name"]
        
        #Look for instructors with matching names in database
        possibleInstrs = Instructor.where(email: response["email"])
        instr = possibleInstrs[0]
        if instr == nil then
            render json: {"create" => true, "name" => username, "email" => response["email"]}
            return
        end
        #If we have any list of instr, just grab the first one. Instructor Creation should check unqiuness
        #Verified info, save instructor id into the session then redirect to dashboard
        session["IUID"] = instr.id
        render json: {"success" => true, "name" => username}
    end
    def logged_in?
        !current_instructor.nil?
    end
    def destroy
         #session.delete("IUID")
         #@current_instructor = nil
         reset_session
         redirect_to root_url
    end
end

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
        #Retrieve POST data
        username = params["username"]
        password = params["password"]
        puts params
        #Look for instructors with matching names in database
        possibleInstrs = Instructor.where(name: username)
        instructor = possibleInstrs[0]
        if instructor == nil then
            #Return error if we do not find anybody
            render json: {"success" => false, "reason" => "Incorrect Username or Password"}
            return
        end
        #If we have any list of instr, just grab the first one. Instructor Creation should check unqiuness
        
        if instructor.password != password then
            #If passwords don't match return error
            render json: {"success" => false, "reason" => "Incorrect Username or Password"}
            return
        end            
        #Verified info, save instructor id into the session then redirect to dashboard
        log_in(instructor)
        render json: {"success" => true}
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

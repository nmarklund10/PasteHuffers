class ILoginController < ApplicationController
    #Shows the instructor login page
    def index
        render "login"
    end
    #Verifies the given credentials
    #If correct then a object telling success is given back and the user is redirected to the dashboard
    def verifyCreds
        #Retrieve POST data
        username = params["username"]
        password = params["password"]
        puts params
        #Look for instructors with matching names in database
        possibleInstrs = Instructor.where(name: username)
        instr = possibleInstrs[0]
        if instr == nil then
            #Return error if we do not find anybody
            render json: {"success" => false, "reason" => "Incorrect Username or Password"}
            return
        end
        #If we have any list of instr, just grab the first one. Instructor Creation should check unqiuness
        
        if instr.password != password then
            #If passwords don't match return error
            render json: {"success" => false, "reason" => "Incorrect Username or Password"}
            return
        end            
        #Verified info, save instructor id into the session then redirect to dashboard
        session["IUID"] = instr.id
        render json: {"success" => true}
    end
end

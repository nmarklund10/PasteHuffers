class SLoginController < ApplicationController
    #List all in database
    def index
        render "s_login2"
    end
    
    def verifyCreds
        #Retrieve POST data
        username = params["username"]
        accessId = params["access"]
        puts params
        #Look for instructors with matching names in database
        possibleAssignment = Assignment.find(accessId)
        assignment = possibleAssignment[0]
        if assignment == nil then
            #Return error if we do not find anybody
            render json: {"success" => false, "reason" => "Access code or Name is empty"}
            return
        end
        #If we have any list of instr, just grab the first one. Instructor Creation should check unqiuness
        
        if assignment.accessId != accessId then
            #If access code does not exist throw error
            render json: {"success" => false, "reason" => "Access code or Name is empty"}
            return
        end            
        #Verified info, save instructor id into the session then redirect to dashboard
        session["AUID"] = assignment.id
        session["SUID"] = username
        render json: {"success" => true}
    end
end

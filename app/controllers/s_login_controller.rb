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
        possibleAssignment = Assignment.where( id: accessId)
        if possibleAssignment.length == 0 then
            #Return error if we do not find anybody
            render json: {"success" => false, "reason" => "Access code or Name is empty"}
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
        session["SUID"] = username
        render json: {"success" => true}
    end
end

class ILoginController < ApplicationController
    #Shows the instructor login page
    def index
        render "login"
    end
    #Verifies the given credentials
    #If correct then a object telling success is given back and the user is redirected to the dashboard
    def verifyCreds
        iuid = params[:id]
        password = params[:password]
        begin
            instr = Instructor.find(iuid)
        rescue
            render j
        end
    end
end

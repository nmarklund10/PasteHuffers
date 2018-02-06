require_relative "../../code_checker/code_checker"
class CeController < ApplicationController
    #List all in database
    def index
        # if session["AUID"] == nil or session["SUID"] == nil then
        #     render json: {"success" => false, "reason" => "No User signed in"}
        #     return
        # end
        render "code_editor"
    end    
    
    def testCode
        begin
            if session["AUID"] == nil or session["SUID"] == nil then
                raise "AUID or SUID was not in session"
            end
            if params["code"] == nil then
                raise "No code given"
            end
            output = CodeChecker.testCode(Assignment.find(session["AUID"]).language, session["SUID"],params["code"])
            render json: {"success" => true, "output" => output}
        rescue Exception => e
            puts e
            render json: {"success" => false, "reason" => "Invalid code test request"}
        end
    end
end

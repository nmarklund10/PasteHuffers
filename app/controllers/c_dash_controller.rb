class CDashController < ApplicationController
    #List all in database
    def index
    end
    
    def getClasses
        iuid = session["IUID"]
        if iuid == nil then render json: [] end
        @courses = Course.where('instructor_id = ?',iuid)
        render json: @courses
    end
   
    #New object. Called when asking for input
    def new
    end
    
    #Creates a record in database
    def create
    end
    
    #Updates record in database
    def update
    end
    
    #CAREFUL! Will not be used for some
    def delete
    end
    
    #Displays one element
    def show
    end
end

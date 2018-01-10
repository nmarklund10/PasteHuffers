require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase
  
  test 'should get assignments' do
    get :getAssignments
    assert_response :success,'doesn\'t get assignments.'
  end
  
  
  test "createAssignmentForm should render correct template and layout" do
    get :createAssignmentForm
    assert_template :createAssignmentForm
    assert_template layout: "layouts/application"
  end
  
  # test "createNewAssignment chould create an assignment" do
  #   get 
  # end
  
  test "getAssignments should get assignments by course id" do
    #get(actionOfController,requestParams[],sessionVariables[],flashValues[])
    get :getAssignments,{'id'=> 1}
    
  end
end
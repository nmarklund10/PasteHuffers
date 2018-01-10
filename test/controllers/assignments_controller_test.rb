require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase
  
  test 'should get assignments' do
    get :getAssignments
    assert_response :success,'doesn\'t get assignments.'
  end
  
  
  test 'createAssignmentForm should render correct template and layout' do
    get :createAssignmentForm
    assert_template :createAssignmentForm, 'assignment form wasn\'t created'
    assert_template layout: 'layouts/application'
  end
  
  test 'getAssignments should get assignments by course id' do
    #get(actionOfController,requestParams[],sessionVariables[],flashValues[])
    get :getAssignments,{'id'=> 1}
    assert_not_empty :getAssignments,'assignment can\'t be empty'
  end
  
  test 'createNewAssignment creates a new assignment correctly' do
    get :createNewAssignment,{'name'=>'some stupid homework', 'language'=>'cpp','CUID'=>'1'}
    #assignment = 
  end
end
require 'test_helper'

class SubmissionsControllerTest < ActionController::TestCase
    test "getSubmissions returns false with no id" do
        get :getSubmissions
  	    response = JSON.parse(@response.body)
  	    assert_equal false, response['success'] 
    end
    test "getSubmissions gets assignments with provided id" do
        get :getSubmissions, {:'id' => '1'}
  	    response = JSON.parse(@response.body)
  	    assert_equal true, response['success'] 
    end
    test "downloadSubmission returns false with no IUID" do
        get :downloadSubmission
        response = JSON.parse(@response.body)
  	    assert_equal false, response['success'] 
    end
    test "massDownloadSubmission returns false with no IUID" do
        get :massDownloadSubmission
        response = JSON.parse(@response.body)
  	    assert_equal false, response['success'] 
    end
end

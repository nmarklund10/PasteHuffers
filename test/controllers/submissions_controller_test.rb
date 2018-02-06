#require 'app/controllers/submissions_controller.rb'
require 'test_helper'

class SubmissionsControllerTest < ActionController::TestCase
    test 'should get submissions by id' do
        get :getSubmissions, {'id' => 1}
        response = JSON.parse(@response.body)
        assert_not_empty "response"
        assert_equal response['submissions'][0]['student_id'],'2'
        assert_equal response['submissions'][1]['student_id'],'1'
    end
end
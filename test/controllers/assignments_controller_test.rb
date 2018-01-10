require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "createAssignmentForm should render correct template and layout" do
    assert_template :index
    assert_template layout: "layouts/application"
  end
end

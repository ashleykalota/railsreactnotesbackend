require "test_helper"

class AmbulanceControllerTest < ActionDispatch::IntegrationTest
  test "should get requests" do
    get ambulance_requests_url
    assert_response :success
  end
end

require "test_helper"

class AmbulanceControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:your_user_fixture)  # Ensure you have a user fixture
    @token = encode_token({ user_id: @user.id })  # Assuming `encode_token` is defined in ApplicationController
  end

  test "should get requests" do
    get ambulance_requests_url, headers: { 'Authorization': "Bearer #{@token}" }
    assert_response :success
  end
end

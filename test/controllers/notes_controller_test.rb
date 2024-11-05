require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one) # Assuming you have a fixture for users
    @note = notes(:one) # Assuming you have a fixture for notes
    @token = encode_token(user_id: @user.id) # Use the method to encode a JWT
  end

  test "should get index" do
    get notes_url, headers: { 'Authorization' => "Bearer #{@token}" }
    assert_response :success
  end

  test "should create note" do
    assert_difference("Note.count") do
      post notes_url, 
           params: { note: { body: "Sample note body", title: "Sample note title", user_id: @user.id } }, 
           headers: { 'Authorization' => "Bearer #{@token}" }, 
           as: :json
    end

    assert_response :created
  end

  test "should show note" do
    get note_url(@note), headers: { 'Authorization' => "Bearer #{@token}" }, as: :json
    assert_response :success
  end

  test "should update note" do
    patch note_url(@note), 
          params: { note: { body: "Updated note body", title: "Updated note title" } }, 
          headers: { 'Authorization' => "Bearer #{@token}" }, 
          as: :json
    assert_response :success
  end

  test "should destroy note" do
    assert_difference("Note.count", -1) do
      delete note_url(@note), headers: { 'Authorization' => "Bearer #{@token}" }, as: :json
    end

    assert_response :no_content
  end
end

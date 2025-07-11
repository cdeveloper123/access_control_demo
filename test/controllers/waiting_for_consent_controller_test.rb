require "test_helper"

class WaitingForConsentControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get waiting_for_consent_index_url
    assert_response :success
  end
end

require "test_helper"

class KnownSecretsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get known_secrets_create_url
    assert_response :success
  end

  test "should get destroy" do
    get known_secrets_destroy_url
    assert_response :success
  end
end

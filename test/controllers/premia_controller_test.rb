require "test_helper"

class PremiaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @premium = premia(:one)
  end

  test "should get index" do
    get premia_url
    assert_response :success
  end

  test "should get new" do
    get new_premium_url
    assert_response :success
  end

  test "should create premium" do
    assert_difference("Premium.count") do
      post premia_url, params: { premium: { name: @premium.name, price_cents: @premium.price_cents } }
    end

    assert_redirected_to premium_url(Premium.last)
  end

  test "should show premium" do
    get premium_url(@premium)
    assert_response :success
  end

  test "should get edit" do
    get edit_premium_url(@premium)
    assert_response :success
  end

  test "should update premium" do
    patch premium_url(@premium), params: { premium: { name: @premium.name, price_cents: @premium.price_cents } }
    assert_redirected_to premium_url(@premium)
  end

  test "should destroy premium" do
    assert_difference("Premium.count", -1) do
      delete premium_url(@premium)
    end

    assert_redirected_to premia_url
  end
end

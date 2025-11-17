require "application_system_test_case"

class PremiaTest < ApplicationSystemTestCase
  setup do
    @premium = premia(:one)
  end

  test "visiting the index" do
    visit premia_url
    assert_selector "h1", text: "Premia"
  end

  test "should create premium" do
    visit premia_url
    click_on "New premium"

    fill_in "Name", with: @premium.name
    fill_in "Price cents", with: @premium.price_cents
    click_on "Create Premium"

    assert_text "Premium was successfully created"
    click_on "Back"
  end

  test "should update Premium" do
    visit premium_url(@premium)
    click_on "Edit this premium", match: :first

    fill_in "Name", with: @premium.name
    fill_in "Price cents", with: @premium.price_cents
    click_on "Update Premium"

    assert_text "Premium was successfully updated"
    click_on "Back"
  end

  test "should destroy Premium" do
    visit premium_url(@premium)
    click_on "Destroy this premium", match: :first

    assert_text "Premium was successfully destroyed"
  end
end

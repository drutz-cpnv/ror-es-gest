require "application_system_test_case"

class PromotionAssertsTest < ApplicationSystemTestCase
  setup do
    @promotion_assert = promotion_asserts(:one)
  end

  test "visiting the index" do
    visit promotion_asserts_url
    assert_selector "h1", text: "Promotion asserts"
  end

  test "should create promotion assert" do
    visit promotion_asserts_url
    click_on "New promotion assert"

    fill_in "Description", with: @promotion_assert.description
    fill_in "Function", with: @promotion_assert.function
    fill_in "Moment", with: @promotion_assert.moment_id
    fill_in "Sector", with: @promotion_assert.sector_id
    click_on "Create Promotion assert"

    assert_text "Promotion assert was successfully created"
    click_on "Back"
  end

  test "should update Promotion assert" do
    visit promotion_assert_url(@promotion_assert)
    click_on "Edit this promotion assert", match: :first

    fill_in "Description", with: @promotion_assert.description
    fill_in "Function", with: @promotion_assert.function
    fill_in "Moment", with: @promotion_assert.moment_id
    fill_in "Sector", with: @promotion_assert.sector_id
    click_on "Update Promotion assert"

    assert_text "Promotion assert was successfully updated"
    click_on "Back"
  end

  test "should destroy Promotion assert" do
    visit promotion_assert_url(@promotion_assert)
    click_on "Destroy this promotion assert", match: :first

    assert_text "Promotion assert was successfully destroyed"
  end
end

require "test_helper"

class PromotionAssertsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @promotion_assert = promotion_asserts(:one)
  end

  test "should get index" do
    get promotion_asserts_url
    assert_response :success
  end

  test "should get new" do
    get new_promotion_assert_url
    assert_response :success
  end

  test "should create promotion_assert" do
    assert_difference("PromotionAssert.count") do
      post promotion_asserts_url, params: { promotion_assert: { description: @promotion_assert.description, function: @promotion_assert.function, moment_id: @promotion_assert.moment_id, sector_id: @promotion_assert.sector_id } }
    end

    assert_redirected_to promotion_assert_url(PromotionAssert.last)
  end

  test "should show promotion_assert" do
    get promotion_assert_url(@promotion_assert)
    assert_response :success
  end

  test "should get edit" do
    get edit_promotion_assert_url(@promotion_assert)
    assert_response :success
  end

  test "should update promotion_assert" do
    patch promotion_assert_url(@promotion_assert), params: { promotion_assert: { description: @promotion_assert.description, function: @promotion_assert.function, moment_id: @promotion_assert.moment_id, sector_id: @promotion_assert.sector_id } }
    assert_redirected_to promotion_assert_url(@promotion_assert)
  end

  test "should destroy promotion_assert" do
    assert_difference("PromotionAssert.count", -1) do
      delete promotion_assert_url(@promotion_assert)
    end

    assert_redirected_to promotion_asserts_url
  end
end

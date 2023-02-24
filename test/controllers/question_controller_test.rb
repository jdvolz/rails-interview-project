require 'test_helper'

class QuestionControllerTest < ActionController::TestCase
  test "should return status 401 when the tenant.api_key does not exist" do
    @request.env['api_key'] = 'invalid_api_key'
    get :index
    assert_response :unauthorized
  end

  test "should return only questions with a keyword" do
    tenant = Tenant.first
    @request.env['api_key'] = tenant.api_key
    KEYWORD = 'keyword'
    get :index, {keyword: KEYWORD}
    assert_response :success

    json = JSON.parse(@response.body)
    assert json.first['title'].match(/#{KEYWORD}/)
    assert json.length == 1
  end

  test "should return an empty response, but success code if there are no matches" do
    tenant = Tenant.first
    @request.env['api_key'] = tenant.api_key
    get :index, {keyword: 'no-matching-keyword'}
    assert_response :success
  end


  test "should get questions, answers and users" do
    tenant = Tenant.first
    @request.env['api_key'] = tenant.api_key
    get :index
    assert_response :success

    json = JSON.parse(@response.body)


    json.each do |question|
      assert question['id'].present?
      assert question['user_id'].present?
      assert question['user_name'].present?
      assert question['title'].present?
      question['answers'].each do |answer|
        assert answer['id'].present?
        assert answer['user_id'].present?
        assert answer['user_name'].present?
        assert answer['body'].present?
      end
    end
  end

  test "should not get questions that are private" do
    tenant = Tenant.first
    @request.env['api_key'] = tenant.api_key
    get :index
    assert_response :success

    json = JSON.parse(@response.body)
    cnt = Question.where(private: false).count
    assert json.count == cnt
  end

  test "should increment the api_request_count for the tenant" do
    tenant = Tenant.first
    @request.env['api_key'] = tenant.api_key
    get :index
    assert_response :success

    tenant.reload
    assert tenant.api_request_count == 1
  end

  test "should have a home page" do
    get :home
    assert_response :success

    assert @response.body.match(/Counts/)

    tenant = Tenant.first

    assert @response.body.match(/#{tenant.name}/)
    assert @response.body.match(/#{tenant.id}/)
  end
end

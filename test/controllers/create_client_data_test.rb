require_relative '../test_helper'

class CreateClientTest < Minitest::Test
  include TestHelpers
  include PayloadHelpers

  def test_it_can_make_client_data
    make_client

    post '/sources/google/data', raw_payload

    assert_equal 200, last_response.status
    assert_equal "Payload created", last_response.body
    assert_equal 1, PayloadRequest.count
  end

  def test_it_returns_an_error_if_data_is_missing
    make_client

    post '/sources/google/data', "payload={\"url\":\"http://google.com\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\":\"\",\"userAgent\":\"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"

    assert_equal 400, last_response.status
    assert_equal "Event can't be blank", last_response.body
    assert_equal 0, PayloadRequest.count
  end

  def test_it_returns_a_specific_error_if_data_is_missing
    make_client

    post '/sources/google/data', "payload={\"url\":\"\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\":\"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"

    assert_equal 400, last_response.status
    assert_equal "Url can't be blank", last_response.body
    assert_equal 0, PayloadRequest.count
  end

  def test_when_there_is_no_payload
    post '/sources/google/data', "payload={\"url\":\"\",\"requestedAt\":\"\",\"respondedIn\":0,\"referredBy\":\"\",\"requestType\":\"\",\"parameters\":[],\"eventName\":\"\",\"userAgent\":\"\",\"resolutionWidth\":\"\",\"resolutionHeight\":\"\",\"ip\":\"\"}"

    assert_equal 403, last_response.status
    assert_equal "Payload contains URL that doesn't have a client with identifier: google.", last_response.body
  end

  def test_when_there_is_a_duplicate_payload
    make_client

    post '/sources/google/data', raw_payload
    post '/sources/google/data', raw_payload


    assert_equal 403, last_response.status
    assert_equal "Payload already exists", last_response.body
    assert_equal 1, PayloadRequest.count
  end

  def test_when_client_doesnt_exist_return_error
    post '/sources/google/data', raw_payload

    assert_equal 403, last_response.status
    assert_equal "Payload contains URL that doesn't have a client with identifier: google.", last_response.body
  end

end

require_relative '../test_helper'

class EventPathingTest < Minitest::Test
  include TestHelpers
  include PayloadHelpers

  def test_it_returns_events
    make_client
    make_payload_request

    get '/sources/google/events/name'

    assert_equal 404, last_response.status
    assert_equal "", last_response.body
  end
end

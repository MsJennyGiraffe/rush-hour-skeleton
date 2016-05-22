require_relative "../test_helper"

class UserCanSeeAnEventsIndexTest < FeatureTest

  def test_user_can_visit_a_specific_client_and_see_stats
    make_payload_request

    visit '/sources/google/events'

    within("h1") do
      assert page.has_content?("Events for Client google")
    end
    
    assert page.has_content?("name")
  end
end

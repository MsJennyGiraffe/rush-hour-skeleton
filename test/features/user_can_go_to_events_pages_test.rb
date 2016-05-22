require_relative "../test_helper"

class UserCanSeeAnEventsIndexTest < FeatureTest

  def test_user_can_visit_a_specific_client_and_see_stats
    make_payload_request

    visit '/sources/google/events/name'

    within("h1") do
      assert page.has_content?("name")
    end

    within("h3") do
      assert page.has_content?("Total occurences of event: 1")
    end

    within(".table") do
      assert page.has_content?("4:00")
      assert page.has_content?("1")
    end
  end

  def test_user_gets_an_error_page_if_clients_events_do_not_exist
    visit 'sources/google/events/eventsssss'

    assert page.has_content?("You encountered an error!")
  end

  def test_user_gets_an_error_page_if_event_does_not_exist
    make_payload_request

    visit 'sources/google/events/eventsssss'
    
    assert page.has_content?("You encountered an error!")
  end
end

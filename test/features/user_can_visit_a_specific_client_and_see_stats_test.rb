require_relative "../test_helper"

class UserCanVisitASpecificClientAndSeeStats < FeatureTest

  def test_user_can_visit_a_specific_client_and_see_stats

    client = Client.create({
      identifier: "google",
      root_url: "www.google.com"
      })

    url = Url.create(address: "www.google.com/about")
    referred_by = ReferredBy.create(name: "www.google.com")
    request_type = RequestType.create(name: "GET")
    event = Event.create(name: "name")
    user_agent_info = UserAgentInfo.create(
      browser:  "Mozilla/5.0" ,
      os:       "Intel Mac OS X 10.8.2",
      version:  "AppleWebKit/537.17 (KHTML, like Gecko)",
      platform: "Chrome/24.0.1309.0 Safari/537.17")
    screen_size = ScreenSize.create(resolution_height: "1080", resolution_width: "900")
    ip = Ip.create(address: "100.10.10.100")

    PayloadRequest.create({
      url_id: url.id,
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 20,
      referred_by_id: referred_by.id,
      request_type_id: request_type.id,
      parameters: [""],
      event_id: event.id,
      user_agent_info_id: user_agent_info.id,
      screen_size_id: screen_size.id,
      ip_id: ip.id,
      client_id: client.id
    })

    visit "/sources/google"

    within(".table") do
      assert page.has_content?("google")
      assert page.has_content?("20 milliseconds")
      assert page.has_content?("GET")
      assert page.has_content?("www.google.com/about")
      assert page.has_content?("Mozilla/5.0")
      assert page.has_content?("Intel Mac OS X")
      assert page.has_content?("1080 x 900")
    end
  end
end

require_relative "../test_helper"

class UserCanGitInformationAboutAClientRelativePath < FeatureTest

  def test_user_can_get_information_about_a_client_relative_path

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

    visit "/sources/google/urls/about"

    assert page.has_content?("google")
    assert page.has_content?("20")
    assert page.has_content?("GET")
    assert page.has_content?("www.google.com")
    assert page.has_content?("Intel Mac OS X 10.8.2")
    assert page.has_content?("Mozilla/5.0")
  end

  def test_if_identifier_does_not_exist_user_sees_error
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

    visit "/sources/google/urls/i_made_this_up"
    assert page.has_content?("www.google.com/i_made_this_up does not exist.")
  end

  def test_it_displays_an_error_if_the_client_does_not_exist
    visit "/sources/dne"

    assert page.has_content?("dne does not exist.")
  end
end

module PayloadHelpers

  def make_client
    Client.create({
      identifier: "google",
      root_url: "www.google.com"
    })
  end

  def make_url
    Url.create(address: "www.google.com/about")
  end

  def make_referred_by
    ReferredBy.create(name: "www.google.com")
  end

  def make_request_type
    RequestType.create(name: "GET")
  end

  def make_event
    Event.create(name: "name")
  end

  def make_user_agent_info
    UserAgentInfo.create(
      browser:  "Mozilla/5.0" ,
      os:       "Intel Mac OS X 10.8.2",
      version:  "AppleWebKit/537.17 (KHTML, like Gecko)",
      platform: "Chrome/24.0.1309.0 Safari/537.17"
    )
  end

  def make_screen_size
    ScreenSize.create(
      resolution_height: "1080",
      resolution_width: "900"
    )
  end

  def make_ip
    Ip.create(address: "100.10.10.100")
  end

  def make_payload_request
    PayloadRequest.create({
      url_id: make_url.id,
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 20,
      referred_by_id: make_referred_by.id,
      request_type_id: make_request_type.id,
      parameters: [""],
      event_id: make_event.id,
      user_agent_info_id: make_user_agent_info.id,
      screen_size_id: make_screen_size.id,
      ip_id: make_ip.id,
      client_id: make_client.id
    })
  end

  def raw_payload
    "payload={\"url\":\"http://google.com\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\":\"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"
  end
end

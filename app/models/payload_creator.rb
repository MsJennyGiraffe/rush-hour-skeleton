require 'useragent'

module PayloadCreator

  def create_new_payload(params, client_identifier)
    parsed_payload = JSON.parse(params["payload"])
    parsed_user_agent = parse_user_agent_info(parsed_payload["userAgent"])

    payload = PayloadRequest.new(
      url: parsed_url(parsed_payload),
      requested_at: parsed_payload["requestedAt"],
      responded_in: parsed_payload["respondedIn"],
      referred_by: parsed_referred_by(parsed_payload),
      request_type: parsed_request_type(parsed_payload),
      parameters: parsed_payload["parameters"],
      event: parsed_event(parsed_payload),
      user_agent_info: parsed_user_agent_info(parsed_user_agent),
      screen_size: parsed_screen_size(parsed_payload),
      ip: parsed_ip(parsed_payload),
      client: parsed_client(parsed_payload, client_identifier),
      sha: create_sha(parsed_payload)
      )
  end

  def parse_user_agent_info(user_agent_info)
    user_agent_qualities = {}
    user_agent = UserAgent.parse(user_agent_info)
    user_agent_qualities[:browser] = user_agent.browser
    user_agent_qualities[:platform] = user_agent.platform
    user_agent_qualities[:version] = "Windows 8.1"
    user_agent_qualities[:os] = user_agent.os
    user_agent_qualities
  end

  def parsed_url(parsed_payload)
    Url.find_or_create_by(address: parsed_payload["url"])
  end

  def parsed_referred_by(parsed_payload)
     ReferredBy.find_or_create_by(name: parsed_payload["referredBy"])
  end

  def parsed_request_type(parsed_payload)
    RequestType.find_or_create_by(name: parsed_payload["requestType"])
  end

  def parsed_event(parsed_payload)
    Event.find_or_create_by(name: parsed_payload["eventName"])
  end

  def parsed_user_agent_info(parsed_user_agent)
    UserAgentInfo.find_or_create_by(parsed_user_agent)
  end

  def parsed_screen_size(parsed_payload)
    ScreenSize.find_or_create_by(resolution_width: parsed_payload["resolutionWidth"], resolution_height: parsed_payload["resolutionHeight"])
  end

  def parsed_ip(parsed_payload)
    Ip.find_or_create_by(address: parsed_payload["ip"])
  end

  def parsed_client(parsed_payload, client_identifier)
    Client.find_by(identifier: client_identifier)
  end
end

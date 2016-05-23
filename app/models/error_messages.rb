module ErrorMessages

  def error_client_has_no_payloads(identifier)
    @error_string = "Client with identifier #{identifier} has no associated payload requests."
  end

  def error_client_does_not_exist(identifier)
    @error_string = "Client with the identifier #{identifier} does not exist."
  end

  def error_event_not_contained_in_client(identifier, event_name)
    @error_string = "Event #{event_name} is not contained in client with identifier #{identifier}."
  end

  def error_client_has_no_associated_payloads(identifier)
    @error_string = "Client with identifier #{identifier} has no associated payload requests."
  end

  def error_full_url_does_not_exist(identifier, relative_path)
    @error_string = "No URL for client #{identifier} exists at relative path #{relative_path}"
  end
end

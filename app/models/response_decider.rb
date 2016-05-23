require_relative '../models/error_messages'

module ResponseDecider
  include ErrorMessages

  def client_response_decider(identifier)
    client_sha = create_sha(params)
    client = Client.new(identifier: params[:identifier], root_url: params[:rootUrl], sha: client_sha)
    if client_sha_exists?(client)
      response_client_already_exists
    else
      if client.save
        response_client_created
      else
        response_list_all_client_errors(client)
      end
    end
  end

  def payload_response_decider(payload, identifier)
    if payload_sha_exists?(payload)
      response_payload_already_exists
    elsif bad_client?(identifier)
      response_payload_does_not_have_client(identifier)
    else
      if payload.save
        response_payload_created
      else
        response_list_all_payload_errors(payload)
      end
    end
  end

  def client_index_response_decider(identifier)
    @client = Client.find_by(identifier: identifier)
    if @client.present?
      @uniq_client_events = @client.events.uniq
      erb :'clients/events/index'
    else
      error_client_does_not_exist(identifier)
      not_found
    end
  end

  def create_client_response_decider(identifier)
    if Client.exists?(identifier: identifier)
      @client =  Client.find_by(identifier: identifier)
      if @client.payload_requests.empty?
        error_client_has_no_associated_payloads(identifier)
        not_found
      else
        erb :'clients/show'
      end
    else
      error_client_does_not_exist(identifier)
      not_found
    end
  end

  def urls_response_decider(identifier, relative_path)
    @client = Client.find_by(identifier: identifier)
    if @client.present?
      @full_url = "#{@client.root_url}" + "/#{relative_path}"
      @full_url_object = @client.urls.find_by(address: @full_url)

      if @full_url_object.present?
        erb :'urls/show'
      else
        error_full_url_does_not_exist(identifier, relative_path)
        not_found
      end
    else
      error_client_does_not_exist(identifier)
      not_found
    end
  end

  def events_response_decider(identifier, event_name)
    @client = Client.find_by(identifier: identifier)
    if @client.present?
      @event = Event.find_by(name: event_name)
        if @event.present?
          if @client.events.find_by(name: @event.name).present?
            @event_payload_requests = @client.payload_requests.where(event_id: @event.id)
            @event_time_hash = @event_payload_requests.group_by{|payload| payload.requested_at.hour}.sort
            erb :'clients/events/show'
          else
            error_event_not_contained_in_client(identifier, event_name)
            not_found
          end
        else
          erb :'clients/events/error', locals: {event_name: event_name}
        end
      else
      error_client_does_not_exist(identifier)
      not_found
    end
  end

  def response_payload_already_exists
    response.status = 403
    response.body = "Payload already exists"
  end

  def response_payload_contains_bad_url
    response.status = 403
    response.body = "Payload contains URL that doesn't exist"
  end

  def response_payload_does_not_have_client(identifier)
    response.status = 403
    response.body = "Payload contains URL that doesn't have a client with identifier: #{identifier}."
  end

  def response_payload_created
    response.status = 200
    response.body = "Payload created"
  end

  def response_list_all_payload_errors(payload)
    response.status = 400
    payload.errors.full_messages.join(", ")
  end

  def response_client_already_exists
    response.status = 403
    response.body = "Client already exists"
  end

  def response_client_created
    response.status = 200
    response.body = "Client created"
  end

  def response_list_all_client_errors(client)
    response.status = 400
    response.body = client.errors.full_messages.join(", ")
  end
end

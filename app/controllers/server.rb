require_relative '../models/unique'
require_relative '../models/payload_creator'
require_relative '../models/response_decider'

module RushHour
  class Server < Sinatra::Base
    include Unique
    include PayloadCreator
    include ResponseDecider

    not_found do
      erb :error
    end

    get '/sources/:identifier' do |identifier|
      if Client.exists?(identifier: identifier)
        @client =  Client.find_by(identifier: identifier)
        if @client.payload_requests.empty?
          @error_string = "Identifier #{identifier} has no associated payload requests."
          not_found
        else
          erb :'clients/show'
        end
      else
        @error_string = "#{identifier} does not exist."
        not_found
      end
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      @client = Client.find_by(identifier: identifier)
      if @client.present?
        @full_url = "#{@client.root_url}" + "/#{relative_path}"
        @full_url_object = @client.urls.find_by(address: @full_url)

        if @full_url_object.present?
          erb :'urls/show'
        else
          @error_string = "#{@full_url} does not exist."
          not_found
        end
      else
        @error_string = "Client with the identifier #{identifier} does not exist."
        not_found
      end
    end

    post '/sources/:identifier/data' do |identifier|
      payload = create_new_payload(params, identifier)
      payload_response_decider(payload, identifier)
    end

    post '/sources' do
      client_response_decider(params)
    end

    get '/sources/:identifier/events' do |identifier|
      @client = Client.find_by(identifier: identifier)
      @uniq_client_events = @client.events.uniq

      erb :'clients/events/index'
    end

    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      @client = Client.find_by(identifier: identifier)
      if @client.present?
        @event = Event.find_by(name: event_name)
          if @event.present?
            if @client.events.find_by(name: @event.name).present?
              @event_payload_requests = @client.payload_requests.where(event_id: @event.id)
              @event_time_hash = @event_payload_requests.group_by{|payload| payload.requested_at.hour}.sort
              erb :'clients/events/show'
            else
              @error_string = "Event #{@event.name} is not contained in client #{identifier}."
              not_found
            end
          else
            erb :'clients/events/error', locals: {event_name: event_name}
          end
        else
        @error_string = "Client with identifier #{identifier} does not exist."
        not_found
      end
    end
  end
end

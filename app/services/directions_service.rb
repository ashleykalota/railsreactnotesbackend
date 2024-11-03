require "httparty"

class DirectionsService
  include HTTParty
  base_uri "https://maps.googleapis.com/maps/api"

  # Method for getting directions
  def get_directions(origin, destination)
    api_key = ENV['GOOGLE_MAPS_API_KEY'] # Access your API key
    query = {
      origin: origin,
      destination: destination,
      key: api_key
    }
    response = self.class.get('/directions/json', query: query) # Make the API request
    if response.success?
      response
    else
      { error: "Unable to fetch directions" }
    end
  end

  # Method for getting distance and duration
  def get_distance_and_time(origins, destinations)
    api_key = ENV['GOOGLE_MAPS_API_KEY'] # Access your API key
    query = {
      origins: origins,
      destinations: destinations,
      key: api_key
    }
    response = self.class.get('/distancematrix/json', query: query) # Make the API request
    if response.success?
      response
    else
      { error: "Unable to fetch distance and time" }
    end
  end

end

class LocationsController < ApplicationController
  # Skip authentication for the `api_key` action only
  skip_before_action :authenticate_user!, only: [:api_key]

  # Action to fetch the Google Maps API key
  def api_key
    render json: { api_key: ENV['GOOGLE_MAPS_API_KEY'] }
  end

  # Action to get directions from origin to destination
  def directions
    origin = params[:origin] # e.g., "Lusaka, Zambia"
    destination = params[:destination] # e.g., "Kabwe, Zambia"
    directions_service = DirectionsService.new

    begin
      # Call the DirectionsService to get directions
      response = directions_service.get_directions(origin, destination)
      
      # Check if the API response is successful and contains valid data
      if response.success? && response["status"] == "OK"
        render json: response.parsed_response, status: :ok
      else
        # If Google Maps API returns an error, return that message
        render json: { error: response["error_message"] || "Unable to fetch directions" }, status: :bad_request
      end

    rescue StandardError => e
      # Handle any unexpected errors
      render json: { error: "Something went wrong: #{e.message}" }, status: :internal_server_error
    end
  end

  # Action to get the distance matrix between origins and destinations
  def distance_matrix
    origins = params[:origins] # e.g., "Lusaka, Zambia"
    destinations = params[:destinations] # e.g., "Kabwe, Zambia"
    directions_service = DirectionsService.new

    begin
      # Call the DirectionsService to get distance and time
      response = directions_service.get_distance_and_time(origins, destinations)
      
      # Check if the API response is successful and contains valid data
      if response.success? && response["status"] == "OK"
        render json: response.parsed_response, status: :ok
      else
        # If Google Maps API returns an error, return that message
        render json: { error: response["error_message"] || "Unable to fetch distance matrix" }, status: :bad_request
      end

    rescue StandardError => e
      # Handle any unexpected errors
      render json: { error: "Something went wrong: #{e.message}" }, status: :internal_server_error
    end
  end
end

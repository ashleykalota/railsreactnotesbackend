class AmbulanceRequestsController < ApplicationController
  # Skip authentication for guests only for ambulance request creation
  skip_before_action :authenticate_user!, only: [:create_request]
  
  # Use `authenticate_user!` for actions that require authorization
  before_action :authenticate_user!, only: [:index, :update_request, :complete_request]

  before_action :check_callbacks

  private

  def check_callbacks
    Rails.logger.debug "Before Action: Check Callbacks"
    # Check if the callback exists
    unless self.class._process_action_callbacks.any? { |cb| cb.filter == :your_callback_method_name }
      Rails.logger.warn "Callback not found"
    end
  end

  # Action for guests to create ambulance requests
  def create_request
    origin = params[:origin]
    destination = params[:destination]
    phone_number = params[:phone_number]

    # Ensure all necessary fields are present
    if origin.present? && destination.present? && phone_number.present?
      # Create a new AmbulanceRequest record
      request = AmbulanceRequest.new(
        origin: origin,
        destination: destination,
        phone_number: phone_number
      )

      # Handle successful and failed request creation
      if request.save
        render json: { message: "Ambulance request created successfully" }, status: :ok
      else
        Rails.logger.error "Error details: #{request.errors.full_messages.join(', ')}"
        render json: { error: "Failed to create request" }, status: :unprocessable_entity
      end
    else
      render json: { error: "All fields are required" }, status: :bad_request
    end
  end

  # Action for admins to view all requests
  def index
    if current_user&.admin?
      requests = AmbulanceRequest.all
      render json: requests, status: :ok
    else
      render json: { error: "Unauthorized" }, status: :forbidden
    end
  end

  # Action for dispatchers to update requests
  def update_request
    if current_user&.dispatcher?
      request = AmbulanceRequest.find(params[:id])
      if request.update(ambulance_request_params)
        render json: { message: "Request updated successfully" }, status: :ok
      else
        Rails.logger.error "Error details: #{request.errors.full_messages.join(', ')}"
        render json: { error: "Failed to update request" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Unauthorized" }, status: :forbidden
    end
  end

  # Action to mark a request as completed
  def complete_request
    if current_user&.admin? || current_user&.dispatcher?
      request = AmbulanceRequest.find(params[:id])
      if request.update(status: "completed")
        render json: { message: "Request marked as completed." }, status: :ok
      else
        Rails.logger.error "Error details: #{request.errors.full_messages.join(', ')}"
        render json: { error: "Failed to complete request" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Unauthorized" }, status: :forbidden
    end
  end

  # Strong parameters to whitelist fields
  def ambulance_request_params
    params.require(:ambulance_request).permit(:origin, :destination, :phone_number, :status)
  end
end

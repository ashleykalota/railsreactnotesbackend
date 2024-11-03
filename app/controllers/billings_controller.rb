class BillingsController < ApplicationController
  def create
    billing = Billing.create(
      user: current_user, 
      ambulance_request_id: params[:ambulance_request_id],
      amount: params[:amount],
      status: "pending"
    )
    if billing.save
      render json: { message: "Billing record created", billing_id: billing.id }, status: :ok
    else
      render json: { error: billing.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    billing = Billing.find(params[:id])
    render json: billing
  end
end

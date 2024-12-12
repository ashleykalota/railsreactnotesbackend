class BillingsController < ApplicationController
  def create
    # Create a billing record with pending status
    billing = Billing.new(
      user: current_user,
      ambulance_request_id: params[:ambulance_request_id],
      amount: params[:amount],
      status: "pending"
    )

    if billing.save
      # Create a Stripe payment intent
      payment_intent = Stripe::PaymentIntent.create(
        amount: (params[:amount] * 100).to_i, # amount in cents
        currency: 'usd', # Change to your preferred currency
        payment_method: params[:payment_method_id],
        confirmation_method: 'manual',
        confirm: true
      )

      # Update billing status based on payment status
      if payment_intent.status == 'succeeded'
        billing.update(status: 'paid')
        render json: { message: "Billing record created and payment successful", billing_id: billing.id }, status: :ok
      else
        billing.update(status: 'failed')
        render json: { message: "Billing record created but payment failed", billing_id: billing.id }, status: :ok
      end

    else
      render json: { error: billing.errors.full_messages }, status: :unprocessable_entity
    end
  rescue Stripe::CardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: "An error occurred: #{e.message}" }, status: :unprocessable_entity
  end

  def show
    billing = Billing.find(params[:id])
    render json: billing
  end

  def calculate_price
    if params[:distance].nil? || params[:service_type].nil?
      render json: { error: 'Missing required parameters' }, status: 400
      return
    end
    # Parameters received from the request
    distance = params[:distance].to_f
    service_type = params[:service_type]
  
    # Example pricing logic
    base_rate = service_type == 'premium' ? 5 : 3
    total_price = distance * base_rate
  
    # Respond with calculated price
    render json: { price: total_price }, status: :ok
   rescue => e
    render json: { error: "An error occurred: #{e.message}" }, status: :unprocessable_entity
  end

  def calculate_price_for_service_type(distance, service_type)
    # Example calculation logic
    base_rate = service_type == 'premium' ? 200 : 100
    price = base_rate + (distance * 10) # Example pricing formula
    price
  end
  
end

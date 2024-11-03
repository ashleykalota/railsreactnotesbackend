class Billing < ApplicationRecord
  belongs_to :user
  belongs_to :ambulance_request

  def calculate_amount(booking)
    base_rate = 10 # Base amount for the booking
    distance_charge = booking.distance * 2 # Charge based on distance (e.g., 2 units per km)
    base_rate + distance_charge
  end
end

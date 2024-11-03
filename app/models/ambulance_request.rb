class AmbulanceRequest < ApplicationRecord
  has_one :billing
  belongs_to :user
  validates :origin, :destination, :phone_number, presence: true

  after_update :generate_bill, if: -> { saved_change_to_status_status? && status == "completed" }

  def generate_bill 
    amount = Billing.calculate_amount(self) 
    Billing.create(user: user, ambulance_request: self, amount: amount, status: "pending")
  end
end

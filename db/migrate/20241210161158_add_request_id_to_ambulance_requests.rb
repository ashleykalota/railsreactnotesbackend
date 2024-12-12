class AddRequestIdToAmbulanceRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :ambulance_requests, :requestID, :string
    add_index :ambulance_requests, :requestID, unique: true
  end
end

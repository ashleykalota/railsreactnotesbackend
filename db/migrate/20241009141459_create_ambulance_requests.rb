class CreateAmbulanceRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :ambulance_requests do |t|
      t.string :origin
      t.string :destination
      t.string :phone_number

      t.timestamps
    end
  end
end

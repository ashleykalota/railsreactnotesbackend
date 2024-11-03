class CreateBillings < ActiveRecord::Migration[7.2]
  def change
    create_table :billings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ambulance_request, null: false, foreign_key: true
      t.decimal :amount
      t.string :status
      t.string :payment_method

      t.timestamps
    end
  end
end

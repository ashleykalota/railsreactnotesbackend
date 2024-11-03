class CreateDrivers < ActiveRecord::Migration[7.2]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :status

      t.timestamps
    end
  end
end

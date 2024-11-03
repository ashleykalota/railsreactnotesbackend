class ChangeAgeToPhoneNumberInUsers < ActiveRecord::Migration[7.2]
  def change
    # Remove the 'age' column (assuming it was an integer)
    remove_column :users, :age, :integer
    
    # Add the 'phone_number' column as a string
    add_column :users, :phone_number, :string
  end
end

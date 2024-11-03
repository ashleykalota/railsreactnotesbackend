class AddRoleToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :role, :string, default: "user" # Set default role as 'user'

    # index for faster querying
    add_index :users, :role
  end
end

class AddUsernameToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :username, :string
    add_column :users, :subscribed, :boolean
    add_column :users, :subscription_end, :datetime
  end
end

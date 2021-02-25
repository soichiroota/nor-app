class AddTokenAndTokenExpiredAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :token, :string, index: true, unique: true
    add_column :users, :token_expired_at, :datetime
  end
end

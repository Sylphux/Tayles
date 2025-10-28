class CreateKnownSecrets < ActiveRecord::Migration[8.0]
  def change
    create_table :known_secrets do |t|
      t.belongs_to :user
      t.belongs_to :secret
      t.timestamps
    end
  end
end

class CreateSecrets < ActiveRecord::Migration[8.0]
  def change
    create_table :secrets do |t|
      t.belongs_to :node
      t.string :secret_title
      t.text :secret_content
      t.integer :secret_order
      t.timestamps
    end
  end
end

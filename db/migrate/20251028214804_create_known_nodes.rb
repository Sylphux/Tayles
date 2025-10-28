class CreateKnownNodes < ActiveRecord::Migration[8.0]
  def change
    create_table :known_nodes do |t|
      t.belongs_to :user
      t.belongs_to :node
      t.timestamps
    end
  end
end

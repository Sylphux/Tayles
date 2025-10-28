class CreateNodes < ActiveRecord::Migration[8.0]
  def change
    create_table :nodes do |t|
      t.belongs_to :world
      t.string :node_type
      t.string :node_title
      t.text :public_description
      t.timestamps
    end
  end
end

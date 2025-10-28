class CreateWorldOwners < ActiveRecord::Migration[8.0]
  def change
    create_table :world_owners do |t|
      t.belongs_to :World, index: true
      t.belongs_to :User, index: true
      t.timestamps
    end
  end
end

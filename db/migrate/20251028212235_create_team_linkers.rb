class CreateTeamLinkers < ActiveRecord::Migration[8.0]
  def change
    create_table :team_linkers do |t|
      t.belongs_to :user
      t.belongs_to :node
      t.belongs_to :team
      t.timestamps
    end
  end
end

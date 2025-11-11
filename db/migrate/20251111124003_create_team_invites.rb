class CreateTeamInvites < ActiveRecord::Migration[8.0]
  def change
    create_table :team_invites do |t|
      t.string :invited_email_id
      t.belongs_to :user, index: true
      t.belongs_to :team, index: true
      t.string :status

      t.timestamps
    end
  end
end

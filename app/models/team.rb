class Team < ApplicationRecord
    has_many :team_linkers
    has_many :users, through: :team_linkers
    has_many :nodes, through: :team_linkers
    belongs_to :world
    has_many :team_invites
end

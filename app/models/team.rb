class Team < ApplicationRecord
    has_many :team_linkers
    has_many :users, through: :team_linkers
    has_many :nodes, through: :team_linkers
end

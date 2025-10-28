class Node < ApplicationRecord
    has_many :team_linkers
    has_many :users, through: :team_linkers
    has_many :teams, through: :team_linkers
end

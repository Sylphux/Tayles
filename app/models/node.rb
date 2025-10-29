class Node < ApplicationRecord
    has_many :team_linkers
    has_many :teams, through: :team_linkers
    has_many :known_nodes
    has_many :users, through: :known_nodes
    belongs_to :world, optional: true
    has_many :secrets
end

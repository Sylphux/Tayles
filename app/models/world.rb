class World < ApplicationRecord
    has_many :world_owners
    has_many :users, through: :world_owners
    has_many :nodes
    belongs_to :node, optional: true
end

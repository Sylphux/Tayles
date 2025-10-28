class World < ApplicationRecord
    has_many :world_owners
    has_many :users, through: :world_owners
end

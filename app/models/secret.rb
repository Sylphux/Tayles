class Secret < ApplicationRecord
    has_many :known_secrets
    has_many :users, through: :known_secrets
end

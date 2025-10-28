class KnownSecret < ApplicationRecord
    belongs_to :user
    belongs_to :secret
end

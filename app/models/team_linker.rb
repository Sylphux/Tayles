class TeamLinker < ApplicationRecord
    belongs_to :user
    belongs_to :team
    belongs_to :node, optional: true
end

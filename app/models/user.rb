class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :world_owners
  has_many :worlds, through: :world_owners
  has_many :team_linkers
  has_many :teams, through: :team_linkers
  has_many :nodes, through: :team_linkers
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_create :default_sub # les deux lignes permettent de définir subscribed pour faux à chaque création d'utilisateur
  def default_sub
    self.subscribed ||= false
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :world_owners
  has_many :worlds, through: :world_owners
  has_many :team_linkers
  has_many :teams, through: :team_linkers
  has_many :known_nodes
  has_many :nodes, through: :known_nodes
  has_many :known_secrets
  has_many :secrets, through: :known_secrets
end

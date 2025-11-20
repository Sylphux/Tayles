class StaticController < ApplicationController
  before_action :redirect_to_dashboard, only: [ :home ]

  def dashboard
    @my_worlds = []
    for w in current_user.worlds do
      @my_worlds.push(w.node)
    end

    @explored_worlds = []
    for t in current_user.teams do
      @explored_worlds.push(t.world.node)
    end

    @known_nodes = []
    for n in current_user.nodes do
      if n.node_type != "World"
        @known_nodes.push(n)
      end
    end
  end

  def about
  end

  def home
  end

  def ui_kit
  end

  def premium
  end

  private

  def redirect_to_dashboard # si connecté on veut pas aller sur la page home, on renvoie sur dashboard
    if user_signed_in?
      redirect_to :dashboard
    end
  end
end

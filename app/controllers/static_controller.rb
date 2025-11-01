class StaticController < ApplicationController

  before_action :redirect_to_dashboard, only: [:home]
  
  def dashboard
  end

  def about
  end

  def home
  end

  def ui_kit
  end

  private

  def redirect_to_dashboard #si connecté on veut pas aller sur la page home, on renvoie sur dashboard
    if user_signed_in?
      redirect_to :dashboard
    end
  end

end

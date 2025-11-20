class ApplicationController < ActionController::Base
  before_action :redirect_home, except: [ :home, :about, :ui_kit, :create, :premium ], unless: :devise_controller? # redirige home quand pas connecté sauf si on est dans un controller devise

  include SessionsHelper

  private

  def redirect_home
    if !user_signed_in?
      redirect_to :home
    end
  end
end

class ApplicationController < ActionController::Base
  before_action :require_login, except: [:home] #redirige vers home quand on est pas connecté (sauf depuis la page home elle même)

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def require_login
    unless current_user
      flash[:danger] = "Please log in"
      redirect_to home_path
    end
  end

end

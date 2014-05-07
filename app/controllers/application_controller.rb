class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    session['user_return_to'] || root_path
  end

  def home
    render html: 'Homepage'.html_safe, layout: 'application'
  end
end

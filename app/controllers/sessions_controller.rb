class SessionsController < Devise::SessionsController
  def new
    render :login
  end
end

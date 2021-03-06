class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook

    register_applicant_via_facebook = request.env["omniauth.params"]["register_applicant"] rescue false

    # You need to implement the method below in your model
    raw_info = request.env["omniauth.auth"].extra.raw_info

    email = raw_info.email
    user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if user.persisted?

      flash[:notice] = "Thanks for logging in!"
      sign_in user, :event => :authentication

    end

    where_to_return = env["rack.session"]["user_return_to"] || root_path

    redirect_to where_to_return
  end

  def passthru
  end
end

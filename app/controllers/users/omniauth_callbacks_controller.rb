class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook

    register_applicant_via_facebook = request.env["omniauth.params"]["register_applicant"] rescue false

    # You need to implement the method below in your model
    raw_info = request.env["omniauth.auth"].extra.raw_info

    email = raw_info.email
    user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if user.persisted?

      flash[:notice] = I18n.t("devise.omniauth_callbacks.success")
      sign_in user, :event => :authentication

    end

    redirect_to root_path
  end

  def passthru
  end
end

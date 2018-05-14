class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  protected
  def sign_up_params
    params.require(:user).permit(%i[username email first_name last_name eth_address password password_confirmation referred_by remember_me])
  end

  private
  def check_captcha
    @res = JSON::parse RestClient.get(RECAPTCHA_VERIFY_URL, params: {
      secret: ENV['RECAPTCHA_SECRET_KEY'],
      response: params['g-recaptcha-response'],
      remoteip: request.remote_ip
    }).body

    unless @res['success']
      self.resource = resource_class.new sign_up_params
      resource.validate # Look for any other validation errors besides Recaptcha
      respond_with_navigational(resource) { render 'devise/sessions/new' }
    end
  end
end

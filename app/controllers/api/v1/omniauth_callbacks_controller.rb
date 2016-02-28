class Api::V1::OmniauthCallbacksController < ApiController
  def callback
    auth = env['omniauth.params']
    identity = Identity.find_for_oauth(auth)

    if identity.new_record?
      user = User.from_omniauth
      user.identities << identity
      user.save
    else
      user = identity.user
    end

    if user.valid?
      token = Tiddle.create_and_return_token(user, request)
      render json: { authentication_token: token }
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def failure
    message = params[:message] || 'Authentication failed.'
    render json: { message: message }, status: :unauthorized
  end
end

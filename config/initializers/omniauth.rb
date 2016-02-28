Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = '/api/v1/omniauth'
  end
  provider :gplus, Settings.omniauth.gplus.key, Settings.omniauth.gplus.secret, scope: 'userinfo.email, userinfo.profile'
  provider :facebook, Settings.omniauth.facebook.key, Settings.omniauth.facebook.secret, :scope => 'email, public_profile'
end


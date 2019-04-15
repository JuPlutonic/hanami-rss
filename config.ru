require './config/environment'

run Hanami.app

# # Example Oauth mounted.
# require './config/environment'
# require 'web_bouncer'
# require 'web_bouncer/oauth_middleware'
# require './lib/auth/oauth_container'

# use OmniAuth::Builder do
#   provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], provider_ignores_state: true
# end

# use WebBouncer['middleware.oauth'], model: :account, login_redirect: '/'

# run Hanami.app

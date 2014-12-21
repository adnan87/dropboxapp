class AuthorizationController < ApplicationController

  def authorize
  	# consumer, request_token = get_request_token
  	consumer = Dropbox::API::OAuth.consumer(:authorize)
	request_token = consumer.get_request_token
	# Store the token and secret so after redirecting we have the same request token
	session[:token] = request_token.token
	session[:token_secret] = request_token.secret
	redirect_to request_token.authorize_url(:oauth_callback => 'http://127.0.0.1:3000/authorization/index')

	# binding.pry
	# Here the user goes to Dropbox, authorizes the app and is redirected
	# This would be typically run in a Rails controller

  end

  def index
  	# binding.pry
  	consumer = Dropbox::API::OAuth.consumer(:authorize)
	request_token1 = consumer.get_request_token
  	hash = { oauth_token: request_token1.token, oauth_token_secret: request_token1.secret}
	request_token  = OAuth::RequestToken.from_hash(consumer, hash)
	oauth_verifier = params[:oauth_token]
	binding.pry
	result = request_token.get_access_token(:oauth_verifier => oauth_verifier)
	client = Dropbox::API::Client.new :token => result.token, :secret => result.secret
	 render json: client
  end

  private
  def get_request_token
  	consumer = Dropbox::API::OAuth.consumer(:authorize)
	request_token = consumer.get_request_token
	return consumer, request_token
  end
end

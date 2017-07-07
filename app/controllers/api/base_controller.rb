class Api::BaseController < ApplicationController

	#skip_before_action :verify_authenticity_token
	#skip_before_filter :verify_authenticity_token

	# def current_user
	# 	@user ||= User.find_by(api_key: api_key) unless api_key.nil?
	# end
	#
	#
	# private
	#
	# def api_key
	# 	match = request.headers['AUTHORIZATION']&.match(/^Apikey (.+)/)
	# 	match&.length == 2 ? match[1] : nil
	# end
	#
	# def authenticate_user!
	# 	head :unauthorized unless current_user.present?
	# end
	before_action :authenticate

	def logged_in?
		!!current_user
	end

	def current_user
		if auth_present?
			user = User.find(auth["user"])
			if user
				@current_user ||= user
			end
		end
	end

	def authenticate
		render json: {error: "unauthorized"}, status: 401
			unless logged_in?
			end
	end

	private
	def token
		request.env["HTTP_AUTHORIZATION"].scan(/Bearer
			(.*)$/).flatten.last
	end

	def auth
		Auth.decode(token)
	end
	
	def auth_present?
		!!request.env.fetch("HTTP_AUTHORIZATION",
			"").scan(/Bearer/).flatten.first
	end

end

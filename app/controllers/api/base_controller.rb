class Api::BaseController < ApplicationController
	
	#skip_before_action :verify_authenticity_token
	#skip_before_filter :verify_authenticity_token

	def current_user 
		@user ||= User.find_by(api_key: api_key) unless api_key.nil?
	end

	private

	def api_key 
		match = request.headers['AUTHORIZATION']&.match(/^Apikey (.+)/)
		match&.length == 2 ? match[1] : nil
	end

	def authenticate_user! 
		head :unauthorized unless current_user.present?
	end

end

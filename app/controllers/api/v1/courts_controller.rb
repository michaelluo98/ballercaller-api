class Api::V1::CourtsController < Api::BaseController
	skip_before_action :authenticate
	def index 
		@courts = Court.all
		render json: {
			status: :success, 
			courts: @courts
		}
	end
end

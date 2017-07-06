class Api::V1::CourtsController < Api::BaseController
	def index 
		@courts = Court.all
		render json: {
			status: :success, 
			courts: @courts
		}
	end
end

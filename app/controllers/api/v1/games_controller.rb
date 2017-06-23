class Api::V1::GamesController < Api::BaseController
	before_action :authenticate_user!, except: [:index, :show] 
  before_action :find_game, only: [:show, :update, :destroy]

	def create 
		game = Game.new(game_params)
		if game.save 
			render json: { status: :success, id: game.id }
		else 
			render json: { status: :failure, 
										 error: game.errors.full_messages.join('') }
		end
	end

	private 

	def find_game 
		@game = Game.find_by(id: params[:id])
	end

	def game_params
		params.require(:game).permit(
			:game_mod_id, 
			:mode, 
			:start_time, 
			:extra_info, 
			:status, 
			:court_id
		)
	end

end

#{
	#"game": {
		#"game_mod_id":"5", 
		#"mode":"threes", 
  	#"status":"waiting", 
		#"extra_info":"blahblahblah", 
		#"start_time":"Thu, 22 Jun 2017 22:55:02 -0700", 
		#"court_id":"11"
	#}
#}

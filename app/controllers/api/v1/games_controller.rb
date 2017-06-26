class Api::V1::GamesController < Api::BaseController
	before_action :authenticate_user!, except: [:index, :show] 
  before_action :find_game, only: [:show, :update, :destroy]
	before_action :authenticate_mod!, only: [:destroy, :update]

	def index
		@games = Game.where('start_time > ?', DateTime.now).where(status: 'waiting')
		render json: {
			status: :success, 
			games: @games
		}
	end

	def create 
		game = Game.new(game_params)
		if game.save 
			t = Team.create(game: game, name: "#{game.name} #1")
			Team.create(game: game, name: "#{game.name} #2")
			t.players << current_user
			render json: { status: :success, id: game.id }
		else 
			render json: { status: :failure, 
										 error: game.errors.full_messages.join('') }
		end
	end

	def destroy
		if @game.update(status: 2)
			render json: {
				status: :success, 
				message: "you have successfully deleted you game"
			}
		else 
			render json: {
				status: :failure, 
				errors: @game.errors.full_messages.join(''), 
			}
		end
	end

	def update 
		if @game.update(game_params) 
			render json: {
				status: :success, 
				message: 'you have updated your game'
			}
		else 
			render json: {
				status: :failure,
				errors: @game.errors.full_messages.join('')
			}
		end
	end

	def show 
		teams = Team.where(game: @game)
		render json: {
			status: :success, 
			game: @game,
			teams: teams
		}
	end

	private 

	def find_game 
		@game = Game.find_by(id: params[:id])
	end

	def authenticate_mod! 
		head :unauthorized unless current_user == @game.game_mod
	end

	def game_params
		params.require(:game).permit(
			:game_mod_id, 
			:mode, 
			:start_time, 
			:extra_info, 
			:status, 
			:court_id, 
			:name
		)
	end

	def status_params
		params.require(:game).permit(
			:status
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
		#"court_id":"11", 
    #"name":"blahblah"
	#}
#}

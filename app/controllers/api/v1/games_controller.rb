class Api::V1::GamesController < Api::BaseController
	#before_action :authenticate_user!, except: [:index, :show, :find,
  before_action :find_game, only: [:show, :update, :destroy]
	before_action :authenticate_mod!, only: [:destroy, :update]
	skip_before_action :authenticate

	def index
		@games = Game.where('start_time > ?', DateTime.now)
		@courts = []
		@games.each do |game|
			@courts << Court.find_by(id: game.court_id)
		end
		render json: {
			status: :success,
			games: @games,
			courts: @courts
		}
	end

	def create
		game = Game.new(game_params)
		puts game_params[:game_mod_id]
		if game.save
			UpdateGameStatusJob.set(wait_until: game.start_time).perform_later(game)
			t = Team.create(game: game, name: "#{game.name} #1")
			Team.create(game: game, name: "#{game.name} #2")
			t.players << User.find_by(id: game_params[:game_mod_id])
			render json: { status: :success, 
											id: game.id, 
											teamOneId: game.teams[0].id, 
											teamTwoId: game.teams[1].id}
		else
			render json: { status: :failure,
										 error: game.errors.full_messages.join('') }
		end
	end

	def find 
		name = game_params[:name] == '' ? nil : game_params[:name] 
		mode = game_params[:mode] == '' ? nil : game_params[:mode]
		court_id = game_params[:court_id] == '' ? nil : game_params[:court_id]
		setting = game_params[:setting] == '' ? nil : game_params[:setting]
		games = Game.all
		@courts = []
		if (name) 
			games = games.where(name: name)
		end
		if (mode) 
			games = games.where(mode: mode)
		end
		if (court_id)
			games = games.where(court_id: court_id)
		end
		if (setting)
			games = games.where(setting: setting)
		end
		if (games.length > 0)
			games.each do |game|
				@courts << Court.find_by(id: game.court_id)
			end
		end
		render json: {
			status: :success, 
			games: games, 
			courts: @courts
		}
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
			teamone: teams[0], 
			teamtwo: teams[1]
		}
	end

	def last 
		lastGameId = Game.last.id
		render json: {
			status: :success, 
			lastGameId: lastGameId
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
			:court_id,
			:name, 
			:setting
		)
	end

	def status_params
		params.require(:game).permit(
			:status
		)
	end

end

class Api::V1::UsersController < Api::BaseController
  before_action :find_user, only: [:destroy, :history]
	#before_action :authenticate_user!, only: [:destroy, :history, :update]
	#skip_before_action :verify_authenticity_token
	skip_before_action :authenticate

	def create
		puts user_params
		user = User.new(user_params)
		if user.save
			render json: { user: user, status: :success }
		else
			render json: { status: :failure, errors: user.errors.full_messages.join('') }
		end
	end

	def destroy
		#puts @user
		if @user.destroy
			render json: { message: "user was destroyed", status: :success }
		else
			render json: { status: :failure, errors: @user.errors.full_messages.join('') }
		end
	end

	def history
		@games = []
		@user.teams.each do |team| 
			if !@games.include?(team.game)
				@games.push(team.game) 
			end
		end
		render json: {
			status: :success, 
			games: @games, 
			player: @user
		}
	end

	def favorites 
		@user = User.find_by(id: params[:id]) 
		teammates = @user.favoriteteammates
		favorites = []
		teammates.each do |teammate| 
			favorites << teammate.teammate 
		end

		favoriteteammates = []
		if favorites.count > 10
			favoriteteammates = favorites
		else 
			favoritesId = []
			favorites.each do |friend| 
				favoritesId << friend.id 
			end
			others = User.where.not(id: favoritesId).limit(10)
			favoriteteammates = favorites +  others
		end
		puts "favoriteteammates: #{favoriteteammates}"

		render json: {
			status: :success, 
			favorites: favoriteteammates
		}
	end

	def show 
		user = User.find_by(id: params[:id])
		user ||= User.find_by(email: "#{params[:id]}.com")
		render json: {
			status: :success, 
			user: user
		}
	end

	def update 
		user = User.find_by(id: params[:id]) 
		if (current_user != user)
			head :unauthorized
		elsif user.update(user_params) 
			render json: {
				status: :success, 
				user: user
			}
		else 
			render json: {
				status: :failure, 
				error: user.errors.full_messages.join(' ')
			}
		end
	end

	def historyindex 
		# need to return users historyGames, historyCourts, historyCreators
		@historyGames = []
		@historyCourts = []
		@historyCreators = []
		@user = User.find_by(id: params[:id])
		@user.teams.each do |team| 
			game = team.game
			if !@historyGames.include?(game)
				if (game.start_time < Time.now)
					@historyGames.push(game) 
					@historyCourts.push(Court.find_by(id: game.court_id))
					@historyCreators.push(User.find_by(id: game.game_mod_id))
				end
			end
		end

		render json: {
			status: :success, 
			historyGames: @historyGames, 
			historyCourts: @historyCourts, 
			historyCreators: @historyCreators
		}

	end

	def upcomingindex 
		# return upcomingGames, upcomingCourts, upcomingCreators
		@upcomingGames = []
		@upcomingCourts = []
		@upcomingCreators = []
		@user = User.find_by(id: params[:id])
		@user.teams.each do |team| 
			game = team.game
			if !@upcomingGames.include?(game) 
				if (game.start_time > Time.now)
					@upcomingGames.push(game) 
					@upcomingCourts.push(Court.find_by(id: game.court_id))
					@upcomingCreators.push(User.find_by(id: game.game_mod_id))
				end
			end
		end

		render json: {
			status: :success,
			upcomingGames: @upcomingGames, 
			upcomingCourts: @upcomingCourts, 
			upcomingCreators: @upcomingCreators
		}
	end

	private

	def user_params
		params.require(:user).permit(
			:first_name,
			:last_name,
			:email,
			:password,
			:password_confirmation
		)
	end

	def find_user
		@user = User.find_by(id: params[:id])
	end

end

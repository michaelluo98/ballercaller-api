class Api::V1::TeamsController < Api::BaseController
	before_action :find_team, only: [:join, :quit]
	skip_before_action :authenticate

	def quickjoin 
		game = Game.find_by(id: params[:id])
		currentuser = User.find_by(id: current_user_params[:id])
		teams = Team.where(game: game)
		teamone = teams[0]
		teamtwo = teams[1]
		teamone_len = teamone.players.length
		teamtwo_len = teamtwo.players.length
		team_max = game.read_attribute_before_type_cast(:mode) + 3
		game_max = team_max * 2
		if ((team_max <= teamone_len) && (team_max <= teamtwo_len))
			render json: {
				status: :failure, 
				errors: 'The teams are both already full'
			}
		elsif (teamone_len > teamtwo_len)
			teamtwo.players << currentuser
			if (teamtwo.players.length + teamone.players.length == game_max) 
				game.update(status: 'full')
			end
			render json: {
				status: :success, 
				game: game, 
				newteam: teamtwo, 
				otherteam: teamone
			}
		else 
			teamone.players << currentuser 
			if (teamtwo.players.length + teamone.players.length == game_max) 
				game.update(status: 'full')
			end
			render json: {
				status: :success, 
				game: game, 
				newteam: teamone, 
				otherteam: teamtwo
			}
		end
	end

	def join
		game_mode = @team.game.read_attribute_before_type_cast(:mode)
		if (game_mode + 3) <= @team.players.length 
			render json: {
				status: :failure, 
				message: 'team has exceeded maximum length'
			}
		else 
			@team.players << current_user
			render json: {
				status: :success, 
				message: 'successfully joined team', 
				team: @team, 
				player: current_user
			}
		end
	end

	def quit 
		if @team.players.delete(current_user)
			render json: {
				status: :success, 
				message: 'You have been removed from the team', 
				user: current_user
			}
		else 
			render json: {
				status: :failure, 
				errors: @team.errors.full_messages.join('')
			}
		end
	end

	def index
		@teams = Team.all
		render json: {
			status: :success, 
			teams: @teams
		}
	end

	def players 
		game = Game.find_by(id: params[:id])
		teams = game.teams
		render json: {
			status: :success, 
			playersOne: teams[0].players, 
			playersTwo: teams[1].players
		}
	end

	def jointeam 
		team = Team.find_by(id: params[:id])
		players = team_params[:players_attributes]
		converted = players.to_h

		converted.each do |id|
			puts "#{id[1]['id']} new id"
			newPlayer = User.find_by(id: id[1]['id'])
			team.players << newPlayer
		end

		render json: {
			status: :success, 
			team: team 
		}
	end
	

	private

	def find_team 
		@team = Team.find_by(id: params[:team_id])
	end

	def team_params
		params.require(:team).permit(
			players_attributes: [:id, :first_name, :last_name, :email, :api_key,
												:password_digest, :created_at, :updated_at]
		)
	end

	def current_user_params
		params.require(:user).permit(:id)
	end
end

class Api::V1::TeamsController < Api::BaseController
	def quickjoin 
		game = Game.find_by(id: params[:id])
		teams = Team.where(game: game)
		teamone = teams[0]
		teamtwo = teams[1]
		if (teamone.players.length > teamtwo.players.length)
			teamtwo.players << current_user
			render json: {
				status: :success, 
				game: game, 
				newteam: teamtwo, 
				otherteam: teamone
			}
		else 
			teamone.players << current_user 
			render json: {
				status: :success, 
				game: game, 
				newteam: teamone, 
				otherteam: teamtwo
			}
		end
	end

	def join
		team = Team.find_by(id: params[:team_id])
		game_mode = team.game.read_attribute_before_type_cast(:mode)
		if (game_mode + 3) <= team.players.length 
			render json: {
				status: :failure, 
				message: 'team has exceeded maximum length'
			}
		else 
			team.players << current_user
			render json: {
				status: :success, 
				message: 'successfully joined team', 
				team: team, 
				player: current_user
			}
		end
	end
end

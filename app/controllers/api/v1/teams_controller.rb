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
	end
end

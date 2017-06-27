class UpdateGameStatusJob < ApplicationJob
  queue_as :default

	def create_rows(player1, player2) 
		if (Favoriteteammate
				.where(user: [player, player2],
							teammate: [player, player2]).nil?)
			is_friend = true
			if (Friendship.where(user: player).nil?)
				is_friend = false
			end
			Favoriteteammate.create(user: player, 
															teammate: player2, 
															interactions: 1, 
															is_friend: is_friend)
			Favoriteteammate.create(user: player2, 
															teammate: player, 
															interactions: 1, 
															is_friend: is_friend)
		else 
			rows = Favoriteteammate.where(user: [player, player2], 
																		teammate: [player, player2])
			rows.each do |row| 
				count = row.interactions + 1
				row.update(interactions: count)
			end
		end
	end

	def associate_players(players) 
		n = 0
		first = players[0]
		players.each do |player| 
			players.each do |player2| 
				if (player != first)
					create_rows(player, player2)			
				end
			end
			n += 1
			first = players[n]
		end
	end

	#to start: $ bundle exec rake jobs:work
  def perform(game)
    game.update(status: 'over')
		players = []
		teams = game.teams
		teamone = game.teams[0]
		teamtwo = game.teams[1]
		players.concat(teamone.players)
		players.concat(teamtwo.players)
		associate_players(players)
  end

end

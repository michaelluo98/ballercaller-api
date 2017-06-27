class UpdateGameStatusJob < ApplicationJob
  queue_as :default

	def create_rows(player, player2) 
		if (Favoriteteammate
				.where(user: [player, player2],
							teammate: [player, player2]).nil?)
			is_friend = true
			if (Friendship.find_by(user: player).nil?)
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

	def associate_courts(players, court)
		players.each do |player| 
			f = Favoritecourt.find_by(user: player)
			if (f.nil?)
				Favoritecourt.create(user: player, court: court, count: 1)
			else 
				new_count = f.count + 1 
				f.update(count: new_count)
			end
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
		associate_courts(players, game.court)
  end

end

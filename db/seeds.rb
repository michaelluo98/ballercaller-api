Favoriteteammate.destroy_all
User.delete_all
Court.delete_all
Game.delete_all
Team.delete_all

PASSWORD = 'pass123'

30.times do
	User.create(
		first_name: Faker::Name.first_name,
		last_name: Faker::Name.last_name,
		email: Faker::Internet.email,
		password: PASSWORD
	)
end

User.create(
	first_name: 'Michael',
	last_name: 'Luo',
	email: 'michaelluo98@gmail.com',
	password: PASSWORD
)

users = User.all

courts = Court.create([
	{name: 'Mount Plesant Park', address: '32 W 16th Avenue',
		province: 'BC' , city: 'Vancouver', postal_code: 'V5Y 1Y6'},
	{name: 'Robert Lee YCMA', address: '955 Burrard Street',
		province: 'BC' , city: 'Vancouver', postal_code: 'V6Z 1Y2'},
	{name: 'Hillcret Recreation Centre', address: '4575 Clancy Loranger Way',
		province: 'BC' , city: 'Vancouver', postal_code: 'V5Y 2M4'},
	{name: 'Stanley Park', address: '1166 Stanley Park Drive',
		province: 'BC' , city: 'Vancouver', postal_code: 'V6J 5L1'},
	{name: 'Hastings Park', address: '2901 E Hastings St',
		province: 'BC' , city: 'Vancouver', postal_code: 'V5K'},
	{name: 'Queen Elizabeth Park', address: '33rd Avenue',
		province: 'BC' , city: 'Vancouver', postal_code: 'V5J 5L1'},
	{name: 'Kitsilano Beach Park', address: '1499 Arbutus Street',
		province: 'BC' , city: 'Vancouver', postal_code: 'V6J 5N2'},
	{name: 'Edmonds Community Centre', address: '7433 Edmonds Street',
		province: 'BC' , city: 'Vancouver', postal_code: 'V3N 1B2'},
	{name: '6Pack Beach', address: '13180 Mitchell Road',
		province: 'BC' , city: 'Richmond', postal_code: 'V6V 1M8'}
])

#10.times do
	#Court.create(
		#address: Faker::Address.street_address,
		#postal_code: Faker::Address.zip_code,
		#unit_num: Faker::Address.building_number,
		#city: Faker::Address.city
	#)
#end

#courts = Court.all

modes = [:threes, :fours, :fives]
statuses = [:waiting, :full, :over]

30.times do
	u = users.sample
	g = Game.create(
		game_mod: u,
		name: Faker::Hipster.word,
		mode: modes.sample,
		start_time: Faker::Time.between(Date.today,
																		rand(1..20).days.from_now,
																		:afternoon),
    extra_info: Faker::Hipster.paragraph,
		status: statuses.sample,
		court: courts.sample,
		setting: [true, false].sample
	)
	t = Team.create(game: g, name: "#{g.name} #1")
	t.players << u
	Team.create(game: g, name: "#{g.name} #2")
end

games = Game.all
teams = Team.all

user_length = users.length

users.each do |user|
	teams = []
	rand(1..10).times do
		t = Team.find(rand(1..60))
		if (!teams.include?(t))
			team_max = t.game.read_attribute_before_type_cast(:mode) + 3
			if (t.players.length <= team_max)
				user.teams << t
				teams.push(t)
			end
		end
	end
end

10.times do
	Favoritecourt.create(
		user: users.sample,
		court: courts.sample,
		count: rand(1..10)
	)
end


friendship_statuses = [:requested, :accepted, :rejected]

users.each do |user|
	others = User.where.not(id: user.id)
	rand(0..5).times do

		friend = others.sample
		if (Friendship.where(user: [user, friend], friend: [user, friend]).nil?)
			status = friendship_statuses.sample
			if (status != 'rejected')
				Friendship.create(user: user, friend: friend, status: status)
				Friendship.create(user: friend, friend: user, status: status)
			else
				Friendship.create(user: user, friend: friend, status: 'requested')
				Friendship.create(user: friend, friend: user, status: 'rejected')
			end
		end

	end
end

users.each do |user|
	others = User.where.not(id: user.id)
	rand(0..5).times do
		teammate = others.sample
		if (Favoriteteammate
					.where(user: [user, teammate], teammate: [user, teammate]).length == 0)
			is_friend = true
			if (Friendship.find_by(user: user).nil?)
				is_friend = false
			end
			Favoriteteammate.create(user: user,
															teammate: teammate,
															interactions: rand(1..10),
															is_friend: is_friend)
			Favoriteteammate.create(user: teammate,
															teammate: user,
															interactions: rand(1..10),
															is_friend: is_friend)
		end
	end
end


users.each do |user|
	others = User.where.not(id: user.id)
	rand(0..5).times do
		recipient = others.sample
		Directmessage.create(sender: user,
												 recipient: recipient,
												 message: Faker::Hipster.paragraph)
		Directmessage.create(sender: recipient,
												 recipient: user,
												 message: Faker::Hipster.paragraph)
	end
end

Favoriteteammate.destroy_all
Favoritecourt.destroy_all
User.delete_all
Court.delete_all
Game.delete_all
Team.delete_all

PASSWORD = 'password'

30.times do
	User.create(
		first_name: Faker::Name.first_name,
		last_name: Faker::Name.last_name,
		email: Faker::Internet.email,
		password: PASSWORD, 
		status: [true, false].sample, 
		minimized: true
	)
end

jacky = User.create(
	first_name: 'Jacky',
	last_name: 'Sio',
	email: 'jackysio@gmail.com',
	password: PASSWORD, 
	status: [true, false].sample, 
	minimized: false
)

daniel = User.create(
	first_name: 'Daniel',
	last_name: 'Kim',
	email: 'danielkim@gmail.com',
	password: PASSWORD,
	status: [true, false].sample, 
	minimized: false
)

jason = User.create(
	first_name: 'Jason',
	last_name: 'Tam',
	email: 'jasontam@gmail.com',
	password: PASSWORD,
	status: [true, false].sample, 
	minimized: false
)

spencer = User.create(
	first_name: 'Spencer',
	last_name: 'Cheung',
	email: 'spencercheung@gmail.com',
	password: PASSWORD,
	status: [true, false].sample, 
	minimized: false
)

michael = User.create(
	first_name: 'Michael',
	last_name: 'Luo',
	email: 'michaelluo98@gmail.com',
	password: PASSWORD,
	status: [true, false].sample, 
	minimized: false
)

test1 = User.create(
	first_name: 'Test',
	last_name: 'User One', 
	email: 'test@gmail.com', 
	password: PASSWORD, 
	status: [true, false].sample, 
	minimized: false
)

test2 = User.create(
	first_name: 'Test',
	last_name: 'User Two', 
	email: 'test2@gmail.com', 
	password: PASSWORD, 
	status: [true, false].sample, 
	minimized: false
)
users = User.all

courts = Court.create([
	{name: 'Mount Plesant Park', address: '32 W 16th Avenue',
		province: 'BC' , city: 'Vancouver', postal_code: 'V5Y 1Y6'},
	{name: 'Robert Lee YCMA', address: '955 Burrard Street',
		province: 'BC' , city: 'Vancouver', postal_code: 'V6Z 1Y2'},
	{name: 'Hillcrest Recreation Centre', address: '4575 Clancy Loranger Way',
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

g = Game.create(
	game_mod: daniel,
	name: 'Dominate Jacky',
	mode: modes[0],
	start_time: Faker::Time.between(Date.today,
																	rand(1..20).days.from_now,
																	:afternoon),
	extra_info: "its a good day when you dominate Jacky",
	status: statuses[0],
	court: courts.second,
	setting: true
)

t = Team.create(game: g, name: "#{g.name} #1")
t.players << spencer
t.players << users.sample
t2 = Team.create(game: g, name: "#{g.name} #2")
t2.players << jason

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
friendship_good = [:requested, :accepted]

users.each do |user|
	others = User.where.not(id: user.id)
	rand(0..5).times do

		friend = others.sample
		lottery_num = rand(1..3)
		if (Friendship.where(user: [user, friend], friend: [user, friend]).empty?)
			status = friendship_statuses.sample
			if (status != 'rejected' || lottery_num != 1)
				good_status = friendship_good.sample
				Friendship.create(user: user, friend: friend, status: good_status)
				Friendship.create(user: friend, friend: user, status: good_status)
			else
				Friendship.create(user: user, friend: friend, status: 'requested')
				Friendship.create(user: friend, friend: user, status: 'rejected')
			end
		end

	end
end


Friendship.where(user: test1).destroy_all
Friendship.where(user: test2).destroy_all
Friendship.where(friend: test1).destroy_all
Friendship.where(friend: test2).destroy_all

Friendship.create(user: test1, friend: test2, status: 'accepted')
Friendship.create(user: test2, friend: test1, status: 'accepted')

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

all_friends = [jason, jacky, daniel]

all_friends.each do |friend|
	if (Favoriteteammate
			.where(user: [michael, jacky], teammate: [michael, jacky]).length == 0) 
		Favoriteteammate.create(user: michael, 
														teammate: friend, 
														interactions: rand(11..15),
														is_friend: true)
		Favoriteteammate.create(user: friend, 
														teammate: michael, 
														interactions: rand(11..15),
														is_friend: true)
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

Directmessage.where(sender: test1).destroy_all
Directmessage.where(sender: test2).destroy_all

test_users = [test1, test2]

3.times do 
	idx1 = rand(0..1)
	idx2 = idx1 == 1 ? 0 : 1
	Directmessage.create(sender: test_users[idx1], 
											 recipient: test_users[idx2], 
											 message: Faker::Hipster.sentence)
	Directmessage.create(sender: test_users[idx2], 
											 recipient: test_users[idx1], 
											 message: Faker::Hipster.sentence)
end

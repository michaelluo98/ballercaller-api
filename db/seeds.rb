User.delete_all
Court.delete_all
Game.delete_all
Team.delete_all

PASSWORD = 'pass123'

users = User.create([
	{ first_name: 'Michael', last_name: 'Luo', 
		email: 'michaelluo98@gmail.com', password: PASSWORD }, 
	{ first_name: 'Jon',	last_name: 'Snow', 
		email: 'jonsnow@winterfell.ca', password: PASSWORD }, 
  { first_name: 'Dany', last_name: 'Targ', 
		email: 'danytarg@mereen.ca', password: PASSWORD}, 
	{ first_name: 'Tyrion', last_name: 'Lannister', 
		email: 'tyrionlannister@kingslanding.ca', password: PASSWORD}
])

10.times do 
	Court.create(
		address: Faker::Address.street_address,
		postal_code: Faker::Address.zip_code, 
		unit_num: Faker::Address.building_number, 
		city: Faker::Address.city
	)
end

courts = Court.all

modes = [:threes, :fours, :fives]
statuses = [:waiting, :full, :over]

10.times do 
	Game.create(
		game_mod: users.sample, 
		name: Faker::Hipster.word(3),
		mode: modes.sample,
		start_time: Faker::Time.between(Date.today,
																		rand(1..10).days.from_now,
																		:afternoon), 
    extra_info: Faker::Hipster.paragraph, 
		status: statuses.sample, 
		court: courts.sample 
	)
end

games = Game.all

10.times do 
	Team.create(
		name: Faker::Hipster.word, 
		game: games.sample
	)
end

teams = Team.all
user_length = users.length

# not truly random? the bottom doesnt move with the top 
teams.each do |team| 
	team.players = users.take(rand(1..user_length))
end

10.times do 
	Favoritecourt.create(
		user: users.sample,
		court: courts.sample,
		count: rand(1..10)
	)
end






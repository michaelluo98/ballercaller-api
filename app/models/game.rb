class Game < ApplicationRecord
	# both have to exist for a game to exist
  belongs_to :game_mod, class_name: 'User' 
  belongs_to :court

	has_many :teams

	enum mode: [:threes, :fours, :fives]
	enum status: [:waiting, :full, :over]

end

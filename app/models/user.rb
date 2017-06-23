class User < ApplicationRecord
	has_many :favoritecourts, dependent: :destroy
	has_many :favoriteteammates, dependent: :destroy

	has_many :histories, dependent: :nullify
	has_many :teams, through: :histories, source: :team

	has_one :game_mod, class_name: 'Game', foreign_key: 'game_mod' 

	has_many :sent_direct_messages,
						class_name: 'DirectMessage',
						foreign_key: 'sender_id'
	has_many :received_direct_messages,
						class_name: 'DirectMessage',
						foreign_key: 'recipient_id'

	has_many :friendships 
	has_many :friends, through: :friendships, source: :user, foreign_key: 'friend_id'

	has_many :first_teammate,
						class_name: 'FavoriteTeammate',
						foreign_key: 'user_one_id'
	has_many :second_teammate,
						class_name: 'FavoriteTeammate',
						foreign_key: 'user_two_id'

	has_secure_password
end

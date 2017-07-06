class User < ApplicationRecord
	has_many :favoritecourts, dependent: :destroy
	has_many :favoriteteammates, dependent: :destroy

	has_many :histories, dependent: :nullify
	has_many :teams, through: :histories, source: :team

	has_one :game_mod, class_name: 'Game', foreign_key: 'game_mod' 

	has_many :sent_direct_messages,
						class_name: 'Directmessage',
						foreign_key: 'sender_id'
	has_many :received_direct_messages,
						class_name: 'Directmessage',
						foreign_key: 'recipient_id'

	has_many :friendships
	has_many :friends, 
						through: :friendships
						#source: :user, 
						#dependent: :nullify

	has_many :inverse_friendships, 
					 :class_name => "Friendship", 
					 :foreign_key => "friend_id"
	has_many :inverse_friends, 
					 :through => :inverse_friendships, 
					 :source => :user

	has_many :favoriteteammates 
	has_many :teammates, 
						through: :favoriteteammates, 
						source: :user, 
						foreign_key: 'teammate_id'

	has_secure_password

  def self.from_token_payload payload
    payload['sub']
  end

	private 

	before_create do |user| 
		user.send(:generate_api_key)
	end

  def generate_api_key 
		loop do 
			self.api_key = SecureRandom.hex(32)
			break unless User.exists?(api_key: api_key)
		end
	end


end

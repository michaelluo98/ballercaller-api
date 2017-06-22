class Court < ApplicationRecord
	has_many :games, dependent: :destroy
	has_one :favoritecourt, dependent: :destroy 
end

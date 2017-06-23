class Court < ApplicationRecord
	has_many :games, dependent: :destroy
	has_many :favoritecourts, dependent: :destroy
end

class Team < ApplicationRecord
  belongs_to :game

	has_many :histories, dependent: :destroy
	has_many :players, through: :histories, source: :user

	accepts_nested_attributes_for :players


end

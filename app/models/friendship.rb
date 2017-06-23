class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :teammate, class_name: 'User'

	enum status: [:pending, :requested, :accepted, :rejected]
end

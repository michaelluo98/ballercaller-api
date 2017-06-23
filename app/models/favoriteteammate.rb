class Favoriteteammate < ApplicationRecord
  belongs_to :user
  belongs_to :teammate, class_name: 'User'
end

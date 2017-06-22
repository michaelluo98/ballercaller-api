class History < ApplicationRecord
  belongs_to :user_id
  belongs_to :team
end

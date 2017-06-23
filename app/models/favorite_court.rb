class FavoriteCourt < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :court, optional: true
end

class UpdateGameStatusJob < ApplicationJob
  queue_as :default

  def perform(game)
    game.update(status: 'over')
  end

end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	namespace :api, defaults: {format: :json} do 
		namespace :v1 do 
			resources :users, only: [:create, :destroy]
			resources :games, only: [:create, :update, :destroy, :show, :index]

			get 'users/:id/history', to: 'users#history'

			post 'users/:id/friendships', to: 'friendships#sendrequest'
			patch 'users/:id/friendships/:friend_id/accept', to: 'friendships#accept'
			patch 'users/:id/friendships/:friend_id/reject', to: 'friendships#reject'
			get 'users/:id/friendships', to: 'friendships#index'

			post 'games/:id/quickjoin', to: 'teams#quickjoin'
			post 'games/:id/teams/:team_id', to: 'teams#join'
			patch 'games/:id/teams/:team_id', to: 'teams#quit'
			


		end
	end

end

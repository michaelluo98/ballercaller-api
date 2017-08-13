Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	
	# ActionCable will be listening for Websocket requests on /cable
	mount ActionCable.server => '/cable'

	namespace :api, defaults: {format: :json} do 
		namespace :v1 do 
			get '/games/last', to: 'games#last'
			resources :users, only: [:create, :destroy, :show, :update]
			resources :games, only: [:create, :update, :destroy, :show, :index]
			resources :courts, only: [:index]

			get '/teams', to: 'teams#index'
			post '/teams/:id', to: 'teams#jointeam'
			get '/games/:id/players', to: 'teams#players'
			post '/games/find', to: 'games#find'

			post '/login', to: "sessions#create" 

			get 'users/:id/history', to: 'users#history'
			get 'users/:id/favorites', to: 'users#favorites'
			get 'users/:id/historyindex', to: 'users#historyindex'
			get 'users/:id/upcomingindex', to: 'users#upcomingindex'

			post 'users/:id/friendships/:friend_id/sendrequest', to: 'friendships#sendrequest'
			patch 'users/:id/friendships/:friend_id/accept', to: 'friendships#accept'
			patch 'users/:id/friendships/:friend_id/reject', to: 'friendships#reject'
			get 'users/:id/friendships', to: 'friendships#index'
			get 'users/:id/friendships/:friend_id/status', to: 'friendships#friendship_status'
     
			post 'friendships/:friend_id/directmessages/send', 
						to: 'directmessages#sendmessage'
			get 'friendships/:friend_id/directmessages/', 
						to: 'directmessages#index'
						
			post 'games/:id/quickjoin', to: 'teams#quickjoin'
			post 'games/:id/teams/:team_id', to: 'teams#join'
			patch 'games/:id/teams/:team_id', to: 'teams#quit'


		end
	end

end

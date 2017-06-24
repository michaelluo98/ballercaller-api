Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	namespace :api, defaults: {format: :json} do 
		namespace :v1 do 
			resources :users, only: [:create, :destroy]
			resources :games, only: [:create, :update, :destroy, :show, :index]

			post 'users/:id/friendships', to: 'friendships#sendrequest'
			patch 'users/:id/friendships/:friend_id/accept', to: 'friendships#accept'
			patch 'users/:id/friendships/:friend_id/reject', to: 'friendships#reject'
			get 'users/:id/friendships', to: 'friendships#index'
			


		end
	end

end

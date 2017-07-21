class Api::V1::FriendshipsController < Api::BaseController
	before_action :find_friend, only: [:sendrequest]
	skip_before_action :authenticate

	def sendrequest
		f = Friendship.new(user: current_user, friend: @friend, status: 0)
		if f.save
			render json: {
				status: :success,
				current_user: current_user, 
				friend: @friend
			}
		else 
			render json: {
				status: :failure, 
				error: current_user.errors.full_messages.join('')
			}
		end
	end

	def accept
		u = User.find_by(id: params[:friend_id])
		f = Friendship.find_by(user: u, friend: current_user) 
		puts current_user.id
		puts u.id
		f.assign_attributes(status: 1)
		if f.save 
			new_friendship = Friendship.create(user: current_user, 
																				 friend: u, 
																				 status: 1)
			render json: {
				status: :success, 
				message: 'successfully accepted request', 
				new_friendship: new_friendship
			}
		else 
			render json: {
				status: :failure , 
				message: f.errors.full_messages.join('')
			}
		end
	end

	def reject
		u = User.find_by(id: params[:friend_id])
		f = Friendship.find_by(user: u, friend: current_user)
		f.assign_attributes(status: 2)
		if f.save 
			render json: {
				status: :success, 
				message: 'you have successfully rejected'
			}
		else 
			render json: {
				status: :failure, 
				errors: f.errors.full_messages.join('')
			}
		end
	end

	def index
		requests = []
		friends = []
		u = User.find_by(id: params[:id])
		friendships_all = Friendship.where(user: u) 
		friendships_all.each do |friendship| 
			if (friendship.status == 'requested') 
				requests.push(User.find_by(id: friendship.friend_id))
			elsif (friendship.status == 'accepted') 
				friends.push(User.find_by(id: friendship.friend_id))
			else 
			end
		end
		render json: {
			status: :success, 
			requests: requests, 
			friends: friends
		}
	end

	def friendship_status 
		u = User.find_by(id: params[:id])
		friend = User.find_by(id: params[:friend_id])
		friendship = Friendship.where(user: u, friend: friend)
		friendship_status = ''
		friendship.length == 0 ? 
			friendship_status = 'none' : 
			friendship_status = friendship[0].status
		render json: {
			status: :success, 
			friendship_status: friendship_status
		}
	end

	private 

	def find_friend
		@friend = User.find_by(id: params[:id])
	end

end

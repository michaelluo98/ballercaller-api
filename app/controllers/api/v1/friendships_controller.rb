class Api::V1::FriendshipsController < Api::BaseController
	before_action :find_friend, only: [:sendrequest]
	skip_before_action :authenticate

	def sendrequest
		user = User.find_by(id: params[:id])
		friend = User.find_by(id: params[:friend_id])
		f = Friendship.new(user: user, friend: friend, status: 0)
		if f.save
			render json: {
				status: :success,
				user: user, 
				friend: friend, 
				friendship: f
			}
		else 
			render json: {
				status: :failure, 
				error: current_user.errors.full_messages.join('')
			}
		end
	end

	def accept
		sender = User.find_by(id: params[:friend_id])
		recipient = User.find_by(id: params[:id])
		f = Friendship.find_by(user: sender, friend: recipient) 
		f.assign_attributes(status: 1)
		if f.save 
			new_friendship = Friendship.create(user: recipient, 
																				 friend: sender, 
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
		sender = User.find_by(id: params[:friend_id])
		recipient = User.find_by(id: params[:id])
		f = Friendship.find_by(user: sender, friend: recipient)
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
		#requests_status = []
		u = User.find_by(id: params[:id])
		friendships_all = Friendship.where(friend: u) 
		friendships_all.each do |friendship| 
			if (friendship.status == 'requested') 
				requests.push(User.find_by(id: friendship.user_id))
				#requests_status.push(friendship)
			elsif (friendship.status == 'accepted') 
				friends.push(User.find_by(id: friendship.user_id))
			end
		end
		render json: {
			status: :success, 
			requests: requests, 
			friends: friends, 
			#requests_status: requests_status
		}
	end

	def friendship_status 
		u = User.find_by(id: params[:id])
		friend = User.find_by(id: params[:friend_id])
		friendship = Friendship.where(user: u, friend: friend)
		friendship_status = ''
		if (friendship.length == 0) 
			friendship_status = 'none' 
		else 
			friendship_status = friendship[0].status
		end

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

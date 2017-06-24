class Api::V1::FriendshipsController < Api::BaseController
	before_action :find_friend, only: [:sendrequest]

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
	end

	def reject
	end

	def index
	end

	private 

	def find_friend
		@friend = User.find_by(id: params[:id])
	end

end

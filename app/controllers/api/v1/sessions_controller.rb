class Api::V1::SessionsController < Api::BaseController
  skip_before_action :authenticate

  def create
    user = User.find_by(email: auth_params[:email])
    if user.authenticate(auth_params[:password])
			#ActionCable.server.broadcast "room_#{params[:friend_id]}", 
			#new_message: Directmessage.last
			user.update(status: true)
			ActionCable.server.broadcast "general", { status: true, user: user }
      jwt = Auth.issue({user: user.id})
      render json: {jwt: jwt}
    else
    end
  end

	def logout
		u = User.find_by(id: params[:id])
		if (u.update(status: false))
			ActionCable.server.broadcast "general", { status: false, user: u }
			render json: {
				status: :success
			}
		end
	end

  private
    def auth_params
      params.require(:auth).permit(:email, :password)
    end
    
end

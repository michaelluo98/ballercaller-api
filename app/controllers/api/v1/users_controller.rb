class Api::V1::UsersController < Api::BaseController

	def create
		user = User.new(user_params) 
		
		if user.save
			render json: {id: user.id, status: :success} 
		else 
			render json: { status: :failure, errors: user.errors.full_messages.join('') }
		end

	end

	def destroy
	end

	private 

	def user_params 
		params.require(:user).permit(
			:first_name, 
			:last_name, 
			:email, 
			:password, 
			:password_confirmation
		)
	end

end

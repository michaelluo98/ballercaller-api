class Api::V1::UsersController < Api::BaseController
  before_action :find_user, only: [:destroy, :history]
	before_action :authenticate_user!, only: [:destroy]
	#skip_before_action :verify_authenticity_token

	def create
		user = User.new(user_params)

		if user.save
			render json: { id: user.id, status: :success }
		else
			render json: { status: :failure, errors: user.errors.full_messages.join('') }
		end

	end

	def destroy
		#puts @user
		if @user.destroy
			render json: { message: "user was destroyed", status: :success }
		else
			render json: { status: :failure, errors: @user.errors.full_messages.join('') }
		end
	end

	def history
		@games = []
		@user.teams.each do |team| 
			if !@games.include?(team.game)
				@games.push(team.game) 
			end
		end
		render json: {
			status: :success, 
			games: @games, 
			player: @user
		}
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

	def find_user
		@user = User.find_by(id: params[:id])
	end

end

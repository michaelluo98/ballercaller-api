class Api::V1::UsersController < Api::BaseController
  before_action :find_user, only: [:destroy, :history]
	#before_action :authenticate_user!, only: [:destroy, :history, :update]
	#skip_before_action :verify_authenticity_token
	skip_before_action :authenticate

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

	def show 
		puts '--------------------email------------------'
		puts params[:id]
	
		user = User.find_by(id: params[:id])
		user ||= User.find_by(email: "#{params[:id]}.com")
		render json: {
			status: :success, 
			user: user
		}
		puts '---------------------currentuser---------------------'
		puts user
	end

	def update 
		user = User.find_by(id: params[:id]) 
		if (current_user != user)
			head :unauthorized
		elsif user.update(user_params) 
			render json: {
				status: :success, 
				user: user
			}
		else 
			render json: {
				status: :failure, 
				error: user.errors.full_messages.join(' ')
			}
		end
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

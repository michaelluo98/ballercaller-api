class Api::V1::DirectmessagesController < Api::BaseController
	def sendmessage
		recipient = User.find_by(id: params[:friend_id])
		message = params[:directmessage][:message]
		dm = Directmessage.new(sender: current_user, recipient: recipient, message: message)	
		if dm.save
			render json: {
				status: :success,
				directmessage: dm 
			}
		else 
			render json: {
				status: :failure,
				errors: dm.errors.full_messages.join('')
			}
		end
	end

	def index 

	end

	private

	def message_params 
		params.require(:message)
	end


end

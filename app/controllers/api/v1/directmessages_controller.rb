class Api::V1::DirectmessagesController < Api::BaseController
	def sendmessage
		recipient = User.find_by(id: params[:friend_id])
		message = params[:directmessage][:message]
		dm = Directmessage.new(sender: current_user, recipient: recipient, message: message)
		if dm.save
			# to send data to the subscriber(S) of a channel 'messages' stream
			# ActionCable.server.broadcast 'messages' 
			# 														 content: dm.message,
			# 														 sender: dm.sender,
			# 														 recipient: dm.recipient
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
		friend = User.find_by(id: params[:friend_id])
		sent_dms = Directmessage.where(sender: current_user,
																	 recipient: friend)
		received_dms = Directmessage.where(sender: friend,
																			 recipient: current_user)
		dms = Directmessage.where(sender: [friend, current_user],
															recipient: [friend, current_user])
		render json: {
			status: :success,
			sent: sent_dms,
			received: received_dms,
			dms: dms
		}
	end

	private

	def message_params
		params.require(:directmessage).permit(:message, :sender_id, :recipient_id)
	end


end

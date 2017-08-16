class Api::V1::DirectmessagesController < Api::BaseController
	skip_before_action :authenticate

	def sendmessage
		sender = User.find_by(id: params[:id])
		recipient = User.find_by(id: params[:friend_id])
		message = params[:directmessage][:message]
		dm = Directmessage.new(sender: sender, recipient: recipient, message: message)
		if dm.save
			# to send data to the subscriber(S) of a channel 'messages' stream
			ActionCable.server.broadcast 'room_channel', 
																		content: Directmessage.last(10)
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
		current_user = User.find_by(id: params[:id])
		#friend = User.find_by(id: params[:friend_id])
		sent_dms = Directmessage.where(sender: current_user)
		received_dms = Directmessage.where(recipient: current_user)
		# ??? need to have all from the current_user and/or seperate into chatrooms?
		ActionCable.server.broadcast 'room_channel', 
																	content: Directmessage.last(10)

		render json: {
			status: :success,
			sent: sent_dms,
			received: received_dms
		}
	end

	private

	def message_params
		params.require(:directmessage).permit(:message, :sender_id, :recipient_id)
	end


end

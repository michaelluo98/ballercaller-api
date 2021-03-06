class Api::V1::DirectmessagesController < Api::BaseController
	skip_before_action :authenticate

	def sendmessage
		sender = User.find_by(id: params[:id])
		recipient = User.find_by(id: params[:friend_id])
		message = params[:directmessage][:message]
		dm = Directmessage.new(sender: sender, recipient: recipient, message: message)
		if dm.save
			# to send data to the subscriber(S) of a channel 'messages' stream
			ActionCable.server.broadcast "room_#{params[:friend_id]}", 
																		new_message: Directmessage.last
			render json: {
				status: :success,
				message: dm
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
		current_user_id = current_user.id
		# seperate into object w/ key of other user, and value of arr of messages 
		#     then ordered by date
		unsorted_msgs = Directmessage.where("sender_id = ? or recipient_id = ?", current_user_id, current_user_id)
		chat_ids = []
		# get the unique chat_ids 
		unsorted_msgs.each do |msg| 
			if (!chat_ids.include?(msg.sender_id))
				chat_ids.push(msg.sender_id)
			end 
			if (!chat_ids.include?(msg.recipient_id))
				chat_ids.push(msg.recipient_id)
			end
		end
		chat_ids.delete(current_user_id)

		# sort messages by time 
		sorted_by_time_msgs = unsorted_msgs.order(:created_at)

		# sort messages by chatID
		sorted_msgs = {}
		chat_ids.each do |chat_id| 
			msgs = []
			sorted_by_time_msgs.each do |msg| 
				if (msg.sender_id == chat_id || msg.recipient_id == chat_id) 
					msgs.push(msg)
				end
			end
			sorted_msgs[chat_id] = msgs
		end
		
		render json: {
			status: :success,
			messages: sorted_msgs
		}
	end

	private

	def message_params
		params.require(:directmessage).permit(:message, :sender_id, :recipient_id)
	end


end

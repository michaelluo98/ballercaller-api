class Api::V1::DirectmessagesController < Api::BaseController
	def sendmessage
		recipient = User.find_by(id: params[:friend_id])
		message = params[:message]
		dm = Directmessage.new(sender: current_user, recipient: recipient)	
	end

	def receivemessage
	end

	def index 
	end

	private

	def message_params 
		params.require(:message)
	end


end

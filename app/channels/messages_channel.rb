# Be sure to restart server when modifying this file.
# Action Cable runs in a loop that does not support auto reloading.
class MessagesChannel < ApplicationCable::Channel
	def subscribed 
		stream_from "room_#{params[:room_id]}"
	end
  #def subscribed
    # stream_from "some_channel"
  #end
	#
  #def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  #end
end

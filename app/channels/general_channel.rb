class GeneralChannel < ApplicationCable::Channel
	def subscribed 
		stream_from 'general'
	end
  #def subscribed
    # stream_from "some_channel"
  #end
	#
  #def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  #end
end

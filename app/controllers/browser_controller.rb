require 'reloader/sse'

class BrowserController < ApplicationController
	include ActionController::Live

	def index
		#SSE expects the 'text/event-stream' content type
		response.headers['Content-Type'] = 'text/event-stream'

		sse = Reloader::SSE.new(response.stream)

		begin
			loop do 
				sse.write({:time => Time.now})
				sleep 1
			end  
		rescue IOError #when the client dissconnect, this will send and IOError with the write

		ensure 
			sse.close
		end 
	end 

	# def index
	# 	response.headers['Content-Type'] = 'text/event-stream'
	# 	fail
	# end 
end

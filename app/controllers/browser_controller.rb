require 'reloader/sse'

class BrowserController < ApplicationController
	include ActionController::Live

	def index
		#SSE expects the 'text/event-stream' content type
		response.headers['Content-Type'] = 'text/event-stream'

		sse = Reloader::SSE.new(response.stream)

		begin
			directories = [
				File.join(Rails.root, 'app', 'assets'),
				File.join(Rails.root, 'app', 'views'),
			]
			fsevent = FSEvent.new

			#watch the directories stated above
			fsevent.watch(directories) do |dirs|
				# Send a message on the 'refresh' channel on every update
				sse.write({:dirs => dirs}, :event => 'refresh')
			end
			fsevent.run


		rescue IOError #when the client dissconnect, this will send and IOError with the write

		ensure 
			sse.close
		end 
	end 

	
end

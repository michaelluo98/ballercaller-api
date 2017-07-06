class ApplicationController < ActionController::API
#	protect_from_forgery with: :exception
	include ActionController::Serialization
	include Knock::Authenticable
	
	private
  # Define unauthorized access json response
  def unauthorized_entity(entity_name)
    render json: { error: "Unauthorized request" }, status:     
    :unauthorized
  end
end

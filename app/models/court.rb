class Court < ApplicationRecord
	has_many :games, dependent: :destroy
	has_many :favoritecourts, dependent: :destroy

	geocoded_by :full_address
	after_validation :geocode

	#def court_params
		#params.require(:court).permit(:address, :city, :province, :postal_code)	
	#end

	def full_address
		params[:court][:address] + ', ' + params[:court][:city] + ', ' + 
			params[:court][:province] + ' ' + params[:court][:postal_code]
	end

	def full_address 
		"#{address} #{city}, #{province} #{postal_code}"
	end

end

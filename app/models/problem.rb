# == Schema Information
#
# Table name: problems
#
#  id          :integer         not null, primary key
#  user        :string(255)
#  latitude    :float
#  longitude   :float
#  ptype       :integer
#  description :string(255)
#  priority    :integer
#  status      :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#
class Problem < ActiveRecord::Base

	acts_as_gmappable :latitude => 'latitude', :longitude => 'longitude', :process_geocoding => :geocode?,
                  :address => "address", :normalized_address => "address",
                  :msg => "Lo sentimos, ni Google puede localizar esa direccion"



	attr_accessible :user, :latitude, :longitude, :ptype, :description, :avatar, :address
	validates(:user, presence: true)
	validates(:latitude, presence: true)
	validates(:longitude, presence: true)
	validates(:ptype, presence: true)

	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>"}, :url => "/assets/problems/:id/:style/:basename.:extension", :path => ":rails_root/public/assets/problems/:id/:style/:basename.:extension"

	# :styles => { :small => "150x150>", :medium => "300x300>", :thumb => "100x100>"},

	validates_attachment_presence :avatar
	validates_attachment_size :avatar, :less_than => 5.megabytes
	validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']

	def gmaps4rails_address
		#describe how to retrieve the address from your model, if you use directly a db column, you can dry your code
		"#{self.latitude}, #{self.longitude}" 
	end

	def gmaps4rails_infowindow
    	"<img src=\"#{self.avatar.url(:thumb)}\"> #{self.id} #{self.description}"
    end

    def gmaps4rails_title
    	"#{self.description}"
    end

    def geocode?
  		(!address.blank? && (latitude.blank? || longitude.blank?)) || address_changed?
	end

end

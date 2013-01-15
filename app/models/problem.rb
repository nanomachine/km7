# == Schema Information
#
# Table name: problems
#
#  id          :integer         not null, primary key
#  user_id     :integer
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
	belongs_to :user
	has_and_belongs_to_many :lists

	attr_reader :avatar_remote_url

	#Mapping column information to gmaps marker
	acts_as_gmappable :latitude => 'latitude', :longitude => 'longitude', :process_geocoding => :geocode?,
                  :address => "address", :normalized_address => "address",
                  :msg => "Lo sentimos, ni Google puede localizar esa direccion"

	attr_accessible :user_id, :latitude, :longitude, :ptype, :description, :avatar, :address, :municipality
	validates(:user_id, presence: true)
	validates(:latitude, presence: true)
	validates(:longitude, presence: true)
	validates(:ptype, presence: true)


	#Determine where to store image related to report, in production
	#and in development mode
	if Rails.env.production?
  	has_attached_file :avatar, :styles => {:medium => "400x400#", :thumb => "100x100#"},
					:path => ":rails_root/public/assets/problems/:id/:style/:basename.:extension",
                    :storage => :s3,
					:url => "/assets/problems/:id/:style/:basename.:extension",  
					:s3_credentials => "#{Rails.root}/config/s3.yml",
					:bucket => "km7";
	else
  	has_attached_file :avatar, :styles => {:medium => "400x400#", :thumb => "100x100#"},
  					:path => ":rails_root/public/assets/problems/:id/:style/:basename.:extension",
					:url => "/assets/problems/:id/:style/:basename.:extension";
	end

	validates_attachment_presence :avatar
	validates_attachment_size :avatar, :less_than => 5.megabytes
	validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']


	def gmaps4rails_address
		#describe how to retrieve the address from your model, if you use directly a db column, you can dry your code
		"#{self.latitude}, #{self.longitude}" 
	end

	def gmaps4rails_infowindow
		#<img src=\"#{self.avatar.url(:thumb)}\"> 
    	"#{self.id} #{User.find(self.user_id).name} #{self.latitude} #{self.longitude} #{self.ptype} #{self.description}"
    end

    def gmaps4rails_title
    	"#{self.description}"
    end

    def geocode?
  		(!address.blank? && (latitude.blank? || longitude.blank?)) || address_changed?
	end

end

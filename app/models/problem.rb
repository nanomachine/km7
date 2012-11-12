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

	attr_reader :avatar_remote_url

	acts_as_gmappable :latitude => 'latitude', :longitude => 'longitude', :process_geocoding => :geocode?,
                  :address => "address", :normalized_address => "address",
                  :msg => "Lo sentimos, ni Google puede localizar esa direccion"



	attr_accessible :user, :latitude, :longitude, :ptype, :description, :avatar, :address, :municipality
	validates(:user, presence: true)
	validates(:latitude, presence: true)
	validates(:longitude, presence: true)
	validates(:ptype, presence: true)


	if Rails.env.production?
  	has_attached_file :avatar, :styles => {:medium => "400x400>", :thumb => "100x100>"},
					:path => ":rails_root/public/assets/problems/:id/:style/:basename.:extension",
                    :storage => :s3,
					:url => "/assets/problems/:id/:style/:basename.:extension",  
					:s3_credentials => "#{Rails.root}/config/s3.yml",
					:bucket => "km7";
	else
  	has_attached_file :avatar, :styles => {:medium => "400x400>", :thumb => "100x100>"},
  					:path => ":rails_root/public/assets/problems/:id/:style/:basename.:extension",
					:url => "/assets/problems/:id/:style/:basename.:extension";
	end

	
	#has_attached_file :avatar,
	#:styles => { :medium => "400x400>", :thumb => "100x100>"};
	#:url => "/assets/problems/:id/:style/:basename.:extension", 
	#:path => ":rails_root/public/assets/problems/:id/:style/:basename.:extension"
	#:storage => :s3,
	#:s3_credentials => "#{Rails.root}/config/s3.yml",
	#:bucket => "km7_dev";


	#has_attached_file :avatar,
	#:styles => { :medium => "400x400>", :thumb => "100x100>"}, 
	#:url => "/assets/problems/:id/:style/:basename.:extension", 
	#:path => ":rails_root/public/assets/problems/:id/:style/:basename.:extension";


	# models/photo.rb
	#has_attached_file :image,
	#  :styles => { :thumbnail => "100x100>" },
	#  :storage => :s3,
	#  :s3_credentials => "#{Rails.root}/config/s3.yml",
	#  :bucket => "your_unique_s3_bucket";


	# :styles => { :small => "150x150>", :medium => "300x300>", :thumb => "100x100>"},

	validates_attachment_presence :avatar
	validates_attachment_size :avatar, :less_than => 5.megabytes
	validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']

	#def gmaps4rails_marker_picture
 	#{
   	#"picture" => ('/images/markers/#{self.ptype}.png'),
   	#"width" => 20,
  	#"height" => 20,
   	#"marker_anchor" => [ 5, 10]
  	#}
	#end

	def gmaps4rails_address
		#describe how to retrieve the address from your model, if you use directly a db column, you can dry your code
		"#{self.latitude}, #{self.longitude}" 
	end

	def gmaps4rails_infowindow
		#<img src=\"#{self.avatar.url(:thumb)}\"> 
    	"#{self.id} #{self.user} #{self.latitude} #{self.longitude} #{self.ptype} #{self.description}"
    end

    def gmaps4rails_title
    	"#{self.description}"
    end

    def geocode?
  		(!address.blank? && (latitude.blank? || longitude.blank?)) || address_changed?
	end

end

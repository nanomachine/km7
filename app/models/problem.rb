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

	acts_as_commentable

	attr_reader :avatar_remote_url

	#Mapping column information to gmaps marker
	acts_as_gmappable :latitude => 'latitude', :longitude => 'longitude', :process_geocoding => :geocode?,
                  :address => "address", :normalized_address => "address",
                  :msg => "We're sorry, not even google can find that address, please try again."

	attr_accessible :user_id, :title, :latitude, :longitude, :ptype, :description, :avatar, :address, 
	:municipality, :status, :priority, :c_name, :c_telnum, :c_email

	#The following must be present for the report to be worth anything
	#validates(:title, presence: true)
	validates(:user_id, presence: true)
	validates(:latitude, presence: true)
	validates(:longitude, presence: true)
	validates(:ptype, presence: true)


	#Determine where to store image related to report, in production
	#and in development mode
	if Rails.env.production?
  	has_attached_file :avatar, :styles => {:medium => "767x575#", :thumb => "100x100#"},
					:path => ":rails_root/public/assets/problems/:id/:style/:basename.:extension",
                    :storage => :s3,
					:url => "/assets/problems/:id/:style/:basename.:extension",  
					:s3_credentials => "#{Rails.root}/config/s3.yml",
					:bucket => "km7";
	else
  	has_attached_file :avatar, :styles => {:medium => "767x575", :thumb => "100x100#"},
  					:path => ":rails_root/public/assets/problems/:id/:style/:basename.:extension",
					:url => "/assets/problems/:id/:style/:basename.:extension";
	end

	#Make sure the image attachments are submitted
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
  		#(!address.blank? && (latitude.blank? || longitude.blank?)) || address_changed?
	end

# Helper methods to map integer properties to string values for UI purposes

	def get_prob_type
	    case self.ptype
	    when 1
	       "Pothole"
	    when 2
	       "Water pipe"
	    when 3
	       "Electric cable"
	    when 4
	       "Light post"
	    when 5
	       "Debris in road"
	    when 6
	       "Vandalism"
	    when 7
	       "Manhole cover"
	    else
	       "Unspecified"
	    end
	  end

	def get_prob_status
		case self.status
		when 1
	       "Unassigned"
	    when 2
	       "Assigned"
	    when 3
	       "Resolved"
	    else
	       "Unspecified"
	    end
	end

	def get_prob_priority
		case self.priority
		when 1
	       "Low Priority"
	    when 2
	       "Standard Priority"
	    when 3
	       "High Priority"
	    else
	       "Unspecified"
	    end
	end


end

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
#	acts_as_xlsx :columns => [:id, :title, :latitude, :longitude, :ptype, :description, 
#		:priority, :status, :created_at, :updated_at, :address, :municipality, :user_id, 
#		:assigned_at, :resolved_at, :resolved_id]
	belongs_to :user
	has_and_belongs_to_many :lists

	acts_as_commentable

	attr_reader :avatar_remote_url

	#Mapping column information to gmaps marker
	acts_as_gmappable :latitude => 'latitude', :longitude => 'longitude', :process_geocoding => :geocode?,
                  :address => "address", :normalized_address => "address",
                  :msg => "We're sorry, not even google can find that address, please try again."

	attr_accessible :user_id, :title, :latitude, :longitude, :ptype, :description, :avatar, :address, 
	:municipality, :status, :priority, :assigned_at, :resolved_at, :resolved_id

	#The following must be present for the report to be worth anything,
	#Title validation is commented because mobile app still does not provide one and validation would prevent upload.
	#validates(:title, presence: true, uniqueness: true)
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

	#def gmaps4rails_infowindow
		#<img src=\"#{self.avatar.url(:thumb)}\"> 
    	#{}"<h1 class='h1-infowindow'>##{self.id} - #{self.title}</h1>
    	#<ul>
        #	<li><strong>Address:</strong> #{self.address}</li>
    	#	<li><strong>Latitude:</strong> #{self.latitude} </li>
    	#	<li><strong>Longitude:</strong> #{self.longitude} </li>
   		#	<li><strong>Status:</strong> #{self.get_prob_status} </li>
   		#	<li><strong>Priority:</strong> #{self.get_prob_priority}</li>
    	#</ul>"
    #end

    def gmaps4rails_title
    	"#{self.description}"
    end

    def geocode?
  		#(!address.blank? && (latitude.blank? || longitude.blank?)) || address_changed?
	end

# Helper methods to map integer properties to string values for UI purposes
	def get_owner_name

		@owner = User.find(self.user_id)
		@owner_name = "No last name"
		if @owner.last_name
			@owner_name = @owner.name + " " + @owner.last_name
		end

		return @owner_name
	end

	def is_in_list?
#Este search se debe hacer para las listas activas porque buscar por todas 
#las listas que existen no hace sentido
		@lists = List.all
		@lists.each do |list|
			if list.problems.include?(self)
				return true
			end
		end
		return false
	end

	def get_containing_list
		@lists = List.all
		@lists.each do |list|
			if list.problems.include?(self)
				return list
			end
		end
	end

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
	       "Pending"
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
	       "Low"
	    when 2
	       "Normal"
	    when 3
	       "High "
	    else
	       "Unspecified"
	    end
	end

end


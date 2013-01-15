# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  telnum          :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#

class User < ActiveRecord::Base
  has_many :problems
  has_many :lists

  attr_reader :avatar_remote_url
  
	attr_accessible :name, :email, :telnum, :municipality, :password, :password_confirmation, :admin, :avatar
	has_secure_password

  if Rails.env.production?
    has_attached_file :avatar, :styles => {:medium => "300x300>", :thumb => "100x100>"},
          :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension",
                    :storage => :s3,
          :url => "/assets/users/:id/:style/:basename.:extension",  
          :s3_credentials => "#{Rails.root}/config/s3.yml",
          :bucket => "km7";
  else
    has_attached_file :avatar, :styles => {:medium => "300x300>", :thumb => "100x100>"},
            :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension",
          :url => "/assets/users/:id/:style/:basename.:extension";
  end

  validates_attachment_presence :avatar
  validates_attachment_size :avatar, :less_than => 5.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']


	before_save { self.email.downcase! } 
	before_save :create_remember_token

	validates :name, presence: true, length: { maximum: 50 }
 	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness:  { case_sensitive: false }
  	validates :password, presence: true, length: { minimum: 6 }
    validates :password_confirmation, presence: true

    private

    	def create_remember_token
    		self.remember_token = SecureRandom.urlsafe_base64
    	end

end

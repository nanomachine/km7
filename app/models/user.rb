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
  
	attr_accessible :name, :last_name, :email, :telnum, :municipality, :password, :password_confirmation, :admin, :avatar, :remember_me
	has_secure_password


# Validations upon creating a new user
  validates :name, presence: true, length: { maximum: 50 } , unless: Proc.new { |a| !a.new_record? }
  validates :last_name, presence: true, length: { maximum: 50 }, unless: Proc.new { |a| !a.new_record? }
  validates :telnum, presence: true, length: { maximum: 20 }, unless: Proc.new { |a| !a.new_record? }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness:  { case_sensitive: false }, unless: Proc.new { |a| !a.new_record? }
  validates :password, presence: true, length: { minimum: 6 }, unless: Proc.new { |a| !a.new_record? && a.password.blank? }
  validates :password_confirmation, presence: true, unless: Proc.new { |a| !a.new_record? && a.password_confirmation.blank? }


# Where to store the user avatar depending on the environment
  if Rails.env.production?
    has_attached_file :avatar, :styles => {:medium => "500x500#", :thumb => "100x100#"},
          :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension",
                    :storage => :s3,
          :url => "/assets/users/:id/:style/:basename.:extension",  
          :s3_credentials => "#{Rails.root}/config/s3.yml",
          :bucket => "km7";
  else
    has_attached_file :avatar, :styles => {:medium => "300x300#", :thumb => "100x100#"},
          :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension",
          :url => "/assets/users/:id/:style/:basename.:extension";
  end
# Avatar validations
  validates_attachment_presence :avatar, unless: Proc.new { |a| !a.new_record?}
  validates_attachment_size :avatar, :less_than => 5.megabytes, unless: Proc.new { |a| !a.new_record?}
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png'], unless: Proc.new { |a| !a.new_record?}

# Make sure email is downcased and store the session's remember token.
	before_save { self.email.downcase! }
	before_save { generate_token(:remember_token)}

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver 
  end

  def get_role
    if self.admin
      return "Administrator"
    else
      return "Reporter"
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def assigned_reports
    @total_assigned = []
    self.lists.each do |list|
      if list.active
        list.problems.each do |problem|
          @total_assigned << problem
        end
      end
    end
    return @total_assigned
  end

  def resolved_reports
    @total_resolved = []
#Only reports whose status is 3 are resolved, it is not enough that they have
# resolved_id non-null, that could mean that it was incorrectly marked as resolved
# by someone and has since been corrected back to being Assigned..
    Problem.where(status: 3).each do |p|  
      if p.resolved_id == self.id
        @total_resolved << p
      end
    end
    return @total_resolved
  end

  def self.most_resolved
    @most_resolved = User.first
    User.all.each do |user|
# If the current (new) user's report count is lower, the instanceed user is the one with the most resolved.
      if @most_resolved.resolved_reports.count < user.resolved_reports.count
        @most_resolved = user
      end
    end
    return @most_resolved
  end

  def self.most_assigned
    @most_assigned = User.first
    User.all.each do |user|
      if @most_assigned.assigned_reports.count < user.assigned_reports.count
        @most_assigned = user
      end
    end
    return @most_assigned
  end

  def self.most_submitted 
    @most_submitted = User.first
    User.all.each do |user|
      if @most_submitted.problems.count < user.problems.count
        @most_submitted = user
      end
    end
    return @most_submitted
  end
end


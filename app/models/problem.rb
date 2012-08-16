# == Schema Information
#
# Table name: problems
#
#  id          :integer         not null, primary key
#  user        :string(255)
#  lat         :float
#  lng         :float
#  ptype        :integer
#  description :string(255)
#  priority    :integer
#  status      :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Problem < ActiveRecord::Base
	attr_accessible :user, :lat, :lng, :ptype, :description, :avatar
	validates(:user, presence: true)
	validates(:lat, presence: true)
	validates(:lng, presence: true)
	validates(:ptype, presence: true)

	has_attached_file :avatar, :styles => { :small => "150x150>", :medium => "300x300>", :thumb => "100x100>"}, :url => "/assets/problems/:id/:style/:basename.:extension", :path => ":rails_root/public/assets/problems/:id/:style/:basename.:extension"

	# :styles => { :small => "150x150>", :medium => "300x300>", :thumb => "100x100>"},

	validates_attachment_presence :avatar
	validates_attachment_size :avatar, :less_than => 5.megabytes
	validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']
end



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
	attr_accessible :user, :lat, :lng, :ptype, :description
	validates(:user, presence: true)
	validates(:lat, presence: true)
	validates(:lng, presence: true)
	validates(:ptype, presence: true)
end



class List < ActiveRecord::Base
	belongs_to :user
	has_many :problems

	attr_accessible :user_id, :name, :created_at

end

class List < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :problems, :uniq => true

	attr_accessible :user_id, :name, :created_at, :description
	validates(:user_id, presence: true)
	validates(:name, presence: true)
	validates(:description, presence: true)

end

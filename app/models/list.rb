class List < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :problems, :uniq => true

	attr_accessible :user_id, :name, :created_at, :description, :active
	validates(:user_id, presence: true)
	validates(:name, presence: true, uniqueness: true)
	validates(:description, presence: true)

	def get_owner_name
		@owner = User.find(self.user_id)
		@owner_name = "No last name"
		if @owner.last_name
			@owner_name = @owner.name + " " + @owner.last_name
		end

		return @owner_name
	end

	def get_owner
		@owner = User.find(self.user_id)
		return @owner_name
	end

	def get_status
		if self.active
			return "Active"
		else
			return "Closed"
		end
	end
end

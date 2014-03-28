class Job < ActiveRecord::Base
	validates :title, presence: true, uniqueness: true
	validates :command, presence: true
	validates :cron_input, presence: true

	def check_cron_input
		# find some regex maybe to check if cron input is valid
	end

	# This runs BEFORE initializing a new Job. Jobs should only be
	# added to the database if this is successful
	# link the job to the rufus_id using the return
	def schedule
	end

	# unschedule the job associated with this database entry
	# make sure to call this before destroy!
	def unschedule
		
	end
end

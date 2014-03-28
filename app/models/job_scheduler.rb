class JobScheduler
	@@rscheduler = Rufus::Scheduler.new
	def check_cron_input
		# find some regex maybe to check if cron input is valid
	end

	# This runs BEFORE initializing a new Job. Jobs should only be
	# added to the database if this is successful
	# link the job to the rufus_id using the return
	def self.schedule(title, command, time)
		job_id = @@rscheduler.cron time do
			# Run the command, but puts for now
			puts command
			JobHistory.create(success: true, job_id: Job.where(title: title).first.id)
		end
		return job_id
		#rescue false # in case of bad cron inputs
	end

	# unschedule the job associated with this database entry
	# make sure to call this before destroy!
	def self.unschedule(job)
		cron_job = @@rscheduler.job(job.rufus_id)
		if !cron_job.nil?
			@@rscheduler.unschedule(job.rufus_id)
			cron_job.kill
		end
	end
end
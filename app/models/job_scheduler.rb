class JobScheduler
	@@rscheduler = Rufus::Scheduler.new
	def check_cron_input
		# find some regex maybe to check if cron input is valid
	end

	# This runs BEFORE initializing a new Job. Jobs should only be
	# added to the database if this is successful
	# link the job to the rufus_id using the return
	def self.schedule(job)
			cron_id = @@rscheduler.cron job.cron_input do
				begin
					# Run the command, but puts for now
					puts job.command
					JobHistory.create(success: true, job_id: job.id)
				rescue
					JobHistory.create(success: false, job_id: job.id)
				end
			end
			return cron_id

		#rescue false # in case of bad cron inputs
	end

	# unschedule the job associated with this database entry
	# make sure to call this before destroy!
	def self.unschedule(job)
		job.update(active: false)
		cron_job = @@rscheduler.job(job.rufus_id)
		if !cron_job.nil?
			@@rscheduler.unschedule(job.rufus_id)
			cron_job.kill
		else
			puts "Could not find cron job"
		end
	end

end
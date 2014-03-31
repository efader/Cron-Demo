class JobScheduler
	@@rscheduler = Rufus::Scheduler.new
	def check_cron_input
		# find some regex maybe to check if cron input is valid
	end

	# This runs BEFORE initializing a new Job. Jobs should only be
	# added to the database if this is successful
	# link the job to the rufus_id using the return
	def self.schedule(job)
		begin # the controller will delete the object if this returns nil
			cron_id = @@rscheduler.cron job.cron_input, times: job.times_to_run do
				begin # the only reason this should be false is an error, right?
					# Run the command, but puts for now
					puts job.command
					job.update(next_time: find_next(cron_id))

					if !job.times_to_run.nil? # update the remaining number of runs for those that are finite runs
						job.update(times_to_run: job.times_to_run - 1)
						if job.times_to_run <= 0
							job.update(active: false)
						end
					end
					JobHistory.create(success: true, job_id: job.id)
				rescue
					JobHistory.create(success: false, job_id: job.id)
				end
			end
			job.update(next_time: find_next(cron_id))
			return cron_id
		rescue
			return nil
		end
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

	def self.find_next(job_id)
		return @@rscheduler.job(job_id).next_time
	end

end
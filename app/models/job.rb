class Job < ActiveRecord::Base
	validates :title, presence: true, uniqueness: true
	validates :command, presence: true
	validates :cron_input, presence: true
end

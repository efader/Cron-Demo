json.array!(@jobs) do |job|
  json.extract! job, :id, :title, :command, :cron_input
  json.url job_url(job, format: :json)
end

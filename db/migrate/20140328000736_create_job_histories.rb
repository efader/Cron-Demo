class CreateJobHistories < ActiveRecord::Migration
  def change
    create_table :job_histories do |t|
      t.boolean :success
      t.datetime :scheduled_time
      t.integer :job_id

      t.timestamps
    end
  end
end

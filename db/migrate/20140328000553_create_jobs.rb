class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :command
      t.string :cron_input
      t.string :rufus_id
      t.boolean :active
      t.string :next_time

      t.timestamps
    end
  end
end

class CreateBeachApiCoreJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_jobs do |t|
      t.datetime :start_at
      t.text :params
      t.text :result
      t.boolean :done, default: false

      t.timestamps
    end
  end
end

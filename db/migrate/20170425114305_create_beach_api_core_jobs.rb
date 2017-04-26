class CreateBeachApiCoreJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_jobs do |t|
      t.datetime :start_at
      t.hstore :params, default: {}
      t.hstore :result, default: {}

      t.timestamps
    end
  end
end

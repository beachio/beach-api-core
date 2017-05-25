class AddApplicationToBeachApiCoreJobs < ActiveRecord::Migration[5.1]
  def change
    add_reference :beach_api_core_jobs, :application, foreign_key: { to_table: :oauth_applications }
  end
end

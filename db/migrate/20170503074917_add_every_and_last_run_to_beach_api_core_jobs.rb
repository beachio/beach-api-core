class AddEveryAndLastRunToBeachApiCoreJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :beach_api_core_jobs, :every, :string
    add_column :beach_api_core_jobs, :last_run, :datetime
  end
end

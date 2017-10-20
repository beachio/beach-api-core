class CreateBeachApiCoreOrganisationPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_organisation_plans do |t|
      t.references :organisation
      t.references :plan

      t.timestamps
    end
  end
end

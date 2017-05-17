class AddLogoPropertiesToOrganisation < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_organisations, :logo_properties, :hstore
  end
end

class CreateBeachApiCorePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_permissions do |t|
      t.references :atom
      t.references :keeper, polymorphic: true
      t.hstore :actions, default: {}
      t.timestamps
    end
  end
end

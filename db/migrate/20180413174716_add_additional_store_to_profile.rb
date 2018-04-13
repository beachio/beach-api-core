class AddAdditionalStoreToProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_profiles, :additional_store, :json
  end
end

class AddUseAllBrandsColumnToAchievements < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_achievements, :use_all_config_brands, :boolean, :default => false
  end
end

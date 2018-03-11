class CreateBeachApiCoreDirectories < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_directories do |t|
      t.string :name

      t.timestamps
    end
  end
end

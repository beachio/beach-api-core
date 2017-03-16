class CreateBeachApiCoreAtoms < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_atoms do |t|
      t.string :name, index: { unique: true }
      t.string :title
      t.string :kind
      t.integer :atom_parent_id
      t.timestamps
    end
  end
end

class CreateBeachApiCoreAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_assignments do |t|
      t.references :role
      t.references :user
      t.timestamps
    end
    add_index :beach_api_core_assignments, [:role_id, :user_id], unique: true
  end
end

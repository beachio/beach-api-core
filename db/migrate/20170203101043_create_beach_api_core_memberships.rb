class CreateBeachApiCoreMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_memberships do |t|
      t.references :member, polymorphic: true
      t.references :group, polymorphic: true
      t.boolean    :owner
      t.timestamps
    end
  end
end

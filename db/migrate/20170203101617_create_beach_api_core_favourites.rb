class CreateBeachApiCoreFavourites < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_favourites do |t|
      t.references :user, foreign_key: true
      t.references :favouritable, polymorphic: true, index: { name: 'indexfavourites_on_favouritable_type_and_favouritable_id' }
      t.timestamps
    end
    add_index :beach_api_core_favourites, [:user_id, :favouritable_id, :favouritable_type],
              unique: true, name: 'index_favourites_on_user_id_and_f_id_and_f_type'
  end
end

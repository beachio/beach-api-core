class CreateBeachApiCoreUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_users do |t|
      t.string :email, null: false, index: true
      t.string :username, null: false, index: true
      t.string :password_digest
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end

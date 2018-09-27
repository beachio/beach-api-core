class AddMailBodiesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_mail_bodies do |t|
      t.integer :mail_type
      t.references :application
      t.string :text_color, :default => "#000000"
      t.string :button_color, :default => "#3FD485"
      t.string :button_text_color, :default => "#376E50"
      t.string :button_text, :default => ""
      t.text   :body_text, :default => ""
      t.string :greetings_text, :default => ""
      t.text   :signature_text, :default => ""
      t.string :footer_text, :default => ""
    end
  end
end

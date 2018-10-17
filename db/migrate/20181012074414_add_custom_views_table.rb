class AddCustomViewsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_custom_views do |t|
      t.text   :input_style, default: ""
      t.text   :header_text, default: ""
      t.string :text_color, default: ""
      t.string :success_text_color, default: ""
      t.string :form_background_color, default: ""
      t.string :error_text_color, default: ""
      t.text   :success_text
      t.string   :success_background_color, default: ""
      t.string   :button_text, default: ""
      t.text     :button_style, default: ""
      t.string :form_radius, default: ""
      t.string :success_form_radius, default: ""
      t.integer :view_type
      t.references :application
    end
  end
end

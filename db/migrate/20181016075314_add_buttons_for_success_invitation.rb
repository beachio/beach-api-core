class AddButtonsForSuccessInvitation < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_custom_views, :success_button_first_link, :string, default: ""
    add_column :beach_api_core_custom_views, :success_button_first_icon_type, :string, default: ""
    add_column :beach_api_core_custom_views, :success_button_second_link, :string, default: ""
    add_column :beach_api_core_custom_views, :success_button_second_icon_type, :string, default: ""
    add_column :beach_api_core_custom_views, :success_button_third_link, :string, default: ""
    add_column :beach_api_core_custom_views, :success_button_third_icon_type, :string, default: ""
    add_column :beach_api_core_custom_views, :success_button_first_text, :string, default: ""
    add_column :beach_api_core_custom_views, :success_button_second_text, :string, default: ""
    add_column :beach_api_core_custom_views, :success_button_third_text, :string, default: ""
    add_column :beach_api_core_custom_views, :success_button_style, :text, default: ""
    add_column :beach_api_core_custom_views, :success_button_first_available, :boolean, default: false
    add_column :beach_api_core_custom_views, :success_button_second_available, :boolean, default: false
    add_column :beach_api_core_custom_views, :success_button_third_available, :boolean, default: false
  end
end

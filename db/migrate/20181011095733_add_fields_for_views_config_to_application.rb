class AddFieldsForViewsConfigToApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :oauth_applications, :show_application_logo, :boolean, :default => nil
    add_column :oauth_applications, :application_logo_url, :string, :default => ""
    add_column :oauth_applications, :application_logo_path, :string, :default => ""
    add_column :oauth_applications, :show_instance_logo, :boolean, :default => nil
    add_column :oauth_applications, :provided_text_color, :string, :default => ""
    add_column :oauth_applications, :background_color, :string, :default => ""
    add_column :oauth_applications, :background_image, :string, :default => ""
    add_column :oauth_applications, :background_image_path, :string, :default => ""
    add_column :oauth_applications, :use_default_background_config, :boolean, :default => true
  end
end

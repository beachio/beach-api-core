class AddCustomEmailsConfigToApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :oauth_applications, :mail_type_band_color, :string, :default => "#ff8000"
    add_column :oauth_applications, :mail_type_band_text_color, :string, :default => "#FFFFFF"
    add_column :oauth_applications, :logo_url, :string, :default => ""
    add_column :oauth_applications, :s3_file_path, :string, :default => ""
  end
end

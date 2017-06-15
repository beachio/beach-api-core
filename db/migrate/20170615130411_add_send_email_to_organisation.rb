class AddSendEmailToOrganisation < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_organisations, :send_email, :boolean, default: false
  end
end

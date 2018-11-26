class AddPublisherToApplication < ActiveRecord::Migration[5.1]
  def change
    add_reference :oauth_applications, :publisher, polymorphic: true
  end
end

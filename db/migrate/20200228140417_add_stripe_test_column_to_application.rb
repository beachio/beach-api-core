class AddStripeTestColumnToApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :oauth_applications, :test_stripe, :boolean, default: false
  end
end

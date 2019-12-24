class AddStripeCustomerTokenColumnToOrganisation < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_organisations, :stripe_customer_token, :string
  end
end

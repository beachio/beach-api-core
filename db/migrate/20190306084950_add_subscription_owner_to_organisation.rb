class AddSubscriptionOwnerToOrganisation < ActiveRecord::Migration[5.1]
  def change
    add_reference :beach_api_core_organisations, :subscription_owner
  end
end

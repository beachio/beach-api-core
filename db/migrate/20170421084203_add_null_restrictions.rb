class AddNullRestrictions < ActiveRecord::Migration[5.0]
  def change
    {
      beach_api_core_assets: [:file_id, :entity_id, :entity_type],
      beach_api_core_assignments: [:role_id, :user_id, :keeper_id, :keeper_type],
      beach_api_core_capabilities: [:service_id, :application_id],
      beach_api_core_favourites: [:user_id, :favouritable_id, :favouritable_type],
      beach_api_core_interaction_attributes: [:interaction_id],
      beach_api_core_interaction_keepers: [:interaction_id, :keeper_id, :keeper_type],
      beach_api_core_interactions: [:user_id],
      beach_api_core_invitations: [:user_id, :group_id, :group_type, :role_id],
      beach_api_core_memberships: [:member_id, :member_type, :group_id, :group_type],
      beach_api_core_organisations: [:application_id],
      beach_api_core_permissions: [:atom_id, :keeper_id, :keeper_type],
      beach_api_core_profile_attributes: [:profile_id, :profile_custom_field_id],
      beach_api_core_profile_custom_fields: [:keeper_id, :keeper_type],
      beach_api_core_profiles: [:user_id],
      beach_api_core_services: [:service_category_id],
      beach_api_core_settings: [:keeper_id, :keeper_type],
      beach_api_core_teams: [:application_id],
      beach_api_core_user_preferences: [:user_id, :application_id]
    }.each do |table, columns|
      columns.each do |column|
        change_column_null table, column, false
      end
    end
  end
end

class AddNullRestrictions < ActiveRecord::Migration[5.1]
  def change
    {
      beach_api_core_assets: %i(file_id entity_id entity_type),
      beach_api_core_assignments: %i(role_id user_id keeper_id keeper_type),
      beach_api_core_capabilities: %i(service_id application_id),
      beach_api_core_favourites: %i(user_id favouritable_id favouritable_type),
      beach_api_core_interaction_attributes: %i(interaction_id),
      beach_api_core_interaction_keepers: %i(interaction_id keeper_id keeper_type),
      beach_api_core_interactions: %i(user_id),
      beach_api_core_invitations: %i(user_id group_id group_type role_id),
      beach_api_core_memberships: %i(member_id member_type group_id group_type),
      beach_api_core_organisations: %i(application_id),
      beach_api_core_permissions: %i(atom_id keeper_id keeper_type),
      beach_api_core_profile_attributes: %i(profile_id profile_custom_field_id),
      beach_api_core_profile_custom_fields: %i(keeper_id keeper_type),
      beach_api_core_profiles: %i(user_id),
      beach_api_core_services: %i(service_category_id),
      beach_api_core_settings: %i(keeper_id keeper_type),
      beach_api_core_teams: %i(application_id),
      beach_api_core_user_preferences: %i(user_id application_id)
    }.each do |table, columns|
      columns.each do |column|
        change_column_null table, column, false
      end
    end
  end
end

module BeachApiCore
  SERVICE_KEYS = %i(id title name description icon_url).freeze
  ORGANISATION_KEYS = %i(id name logo_url logo_properties current_user_roles).freeze
  PROFILE_KEYS = %i(id first_name last_name birth_date sex time_zone avatar_url).freeze
  USER_KEYS = %i(id email username profile organisations user_preferences is_me roles scores).freeze
  USER_SIMPLE_KEYS = %i(id email username first_name last_name avatar_url).freeze
  TEAM_KEYS = %i(id name).freeze
  INTERACTION_KEYS = %i(id created_at kind template user interaction_attributes interaction_keepers).freeze
end

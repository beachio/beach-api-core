module BeachApiCore
  SERVICE_KEYS = [:id, :title, :name, :description, :icon_url].freeze
  ORGANISATION_KEYS = [:id, :name, :logo_url, :logo_properties, :current_user_roles].freeze
  PROFILE_KEYS = [:id, :first_name, :last_name, :birth_date, :sex, :time_zone, :avatar_url].freeze
  USER_KEYS = [:id, :email, :username, :profile, :organisations, :user_preferences, :me?].freeze
  TEAM_KEYS = [:id, :name].freeze
end

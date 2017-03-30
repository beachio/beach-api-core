module BeachApiCore::Concerns::V1::ApipieResponseConcern
  include BeachApiCore::Concerns::V1::ApipieConcern

  private

  def apipie_user_response
    pretty BeachApiCore::UserSerializer.new(
      apipie_user, keepers: [BeachApiCore::Instance.current], current_user: apipie_user
    ).as_json
  end

  def apipie_organisation_user_response
    pretty BeachApiCore::OrganisationUserSerializer.new(
      apipie_user, current_organisation: apipie_organisation
    ).as_json
  end

  def apipie_favourite_response
    pretty BeachApiCore::FavouriteSerializer.new(apipie_favourite)
  end

  def apipie_service_category_response
    pretty BeachApiCore::ServiceCategorySerializer.new(apipie_service_category)
  end

  def apipie_invitation_response
    pretty BeachApiCore::InvitationSerializer.new(apipie_invitation)
  end

  def apipie_team_response
    pretty BeachApiCore::TeamSerializer.new(apipie_team)
  end

  def apipie_service_response
    pretty BeachApiCore::ServiceSerializer.new(apipie_service)
  end

  def apipie_application_response
    pretty BeachApiCore::AppSerializer.new(apipie_oauth_application)
  end

  def apipie_organisation_response
    pretty BeachApiCore::OrganisationSerializer.new(apipie_organisation, current_user: apipie_user)
  end

  def apipie_atom_response
    pretty BeachApiCore::AtomSerializer.new(apipie_atom)
  end

  def apipie_actions_response
    pretty(create:  [true, false].sample,
           read:    [true, false].sample,
           update:  [true, false].sample,
           delete:  [true, false].sample,
           execute: [true, false].sample)
  end

  def apipie_role_response
    pretty BeachApiCore::RoleSerializer.new(apipie_role)
  end

end

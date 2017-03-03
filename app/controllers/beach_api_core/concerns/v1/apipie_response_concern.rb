module BeachApiCore::Concerns::V1::ApipieResponseConcern
  extend ActiveSupport::Concern
  include BeachApiCore::Concerns::V1::ApipieConcern

  class_methods do

    private

    def apipie_user_response
      pretty BeachApiCore::UserSerializer.new(apipie_user,
                                              keepers: [BeachApiCore::Instance.current],
                                              current_user: apipie_user).as_json
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
  end
end

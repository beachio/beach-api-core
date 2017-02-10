module BeachApiCore::Concerns::V1::ApipieConcern
  extend ActiveSupport::Concern

  class_methods do

    private

    def apipie_user_response
      pretty BeachApiCore::UserSerializer.new(BeachApiCore::User.new(profile: BeachApiCore::Profile.new))
    end

    def apipie_favorite_response
      pretty BeachApiCore::FavouriteSerializer.new(BeachApiCore::Favourite.new(favouritable: BeachApiCore::User.new))
    end

    def apipie_service_category_response
      pretty BeachApiCore::ServiceCategorySerializer.new(
          BeachApiCore::ServiceCategory.new(services: [BeachApiCore::Service.new])
      )
    end

    def apipie_invitation_response
      pretty BeachApiCore::InvitationSerializer.new(BeachApiCore::Invitation.new(group: BeachApiCore::Team.new))
    end

    def apipie_team_response
      pretty BeachApiCore::TeamSerializer.new(BeachApiCore::Team.new)
    end

    def apipie_service_response
      pretty BeachApiCore::ServiceSerializer.new(BeachApiCore::Service.new)
    end

    def apipie_application_response
      pretty BeachApiCore::AppSerializer.new(BeachApiCore::Doorkeeper::Application.new)
    end

    def apipie_organisation_response
      pretty BeachApiCore::OrganisationSerializer.new(BeachApiCore::Organisation.new)
    end

    def pretty(serializer)
      JSON.pretty_generate serializer.as_json
    end
  end
end

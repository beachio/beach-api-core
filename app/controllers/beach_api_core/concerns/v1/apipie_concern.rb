module BeachApiCore::Concerns::V1::ApipieConcern
  extend ActiveSupport::Concern

  class_methods do

    private

    def apipie_user_response
      JSON.pretty_generate(BeachApiCore::UserSerializer.new(BeachApiCore::User.new(profile: BeachApiCore::Profile.new)).as_json)
    end

    def apipie_favorite_response
      JSON.pretty_generate(BeachApiCore::FavouriteSerializer.new(BeachApiCore::Favourite.new(favouritable: BeachApiCore::User.new)).as_json)
    end

    def apipie_service_category_response
      JSON.pretty_generate(BeachApiCore::ServiceCategorySerializer.new(BeachApiCore::ServiceCategory.new(services: [BeachApiCore::Service.new])).as_json)
    end
  end
end
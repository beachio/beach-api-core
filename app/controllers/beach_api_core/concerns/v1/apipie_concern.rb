module BeachApiCore::Concerns::V1::ApipieConcern
  extend ActiveSupport::Concern

  class_methods do

    private

    def apipie_user_response
      JSON.pretty_generate(BeachApiCore::UserSerializer.new(BeachApiCore::User.new(profile: BeachApiCore::Profile.new)).as_json)
    end
  end
end
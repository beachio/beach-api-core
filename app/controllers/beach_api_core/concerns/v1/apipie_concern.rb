require 'refile/file_double'

module BeachApiCore::Concerns::V1::ApipieConcern
  extend ActiveSupport::Concern

  class_methods do

    def apipie_user
      return @_apipie_user if @_apipie_user
      @_apipie_user = BeachApiCore::User.new(email: Faker::Internet.email)
      @_apipie_user.build_profile(first_name: Faker::Name.first_name,
                                  last_name: Faker::Name.last_name,
                                  sex: BeachApiCore::Profile.sexes.keys.sample,
                                  birth_date: Time.now - rand(50 * 365).days,
                                  avatar: apipie_asset
      )
      @_apipie_user.valid?
      @_apipie_user
    end

    def apipie_asset
      return @_apipie_asset if @_apipie_asset
      @_apipie_asset = BeachApiCore::Asset.new(file: Refile::FileDouble.new('dummy', 'logo.png', content_type: 'image/png'))
    end

    def apipie_favourite
      @_apipie_favourite ||= BeachApiCore::Favourite.new(user: apipie_user, favouritable: apipie_asset)
    end

    def apipie_invitation
      @_apipie_invitation ||= BeachApiCore::Invitation.new(user: apipie_user,
                                                           email: Faker::Internet.email,
                                                           group: apipie_team)
    end

    def apipie_team
      @_apipie_team ||= BeachApiCore::Team.new(name: Faker::Company.name,
                                               application: apipie_oauth_application)
    end

    def apipie_organisation
      @_apipie_organisation ||= BeachApiCore::Organisation.new(name: Faker::Company.name,
                                                               application: apipie_oauth_application)
    end

    def apipie_oauth_application
      @_oauth_application ||= Doorkeeper::Application.new(name: Faker::Company.name,
                                                          redirect_uri: Faker::Internet.redirect_uri,
                                                          owner: apipie_user)
    end

    def apipie_service
      return @_apipie_service if @_apipie_service
      service_category = BeachApiCore::ServiceCategory.new(name: Faker::Name.title)
      @_apipie_service = service_category.services.build(title: Faker::Name.title,
                                                         description: Faker::Lorem.sentence,
                                                         icon: apipie_asset)
      @_apipie_service
    end

    def apipie_service_category
      @_apipie_service_category ||= apipie_service.service_category
    end

    def apipie_instance
      @_apipie_instance ||= BeachApiCore::Instance.new(name: SecureRandom.uuid)
    end

    def pretty(serializer)
      JSON.pretty_generate serializer.as_json
    end

  end
end

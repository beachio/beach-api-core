require 'refile/file_double'

module BeachApiCore::Concerns::V1::ApipieConcern
  def apipie_user
    return @_apipie_user if @_apipie_user
    @_apipie_user = BeachApiCore::User.new(id: fake_id, email: Faker::Internet.email)
    @_apipie_user.build_profile(first_name: Faker::Name.first_name,
                                last_name: Faker::Name.last_name,
                                sex: BeachApiCore::Profile.sexes.keys.sample,
                                birth_date: Time.now - rand(50 * 365).days,
                                avatar: apipie_asset)
    @_apipie_user.organisations = [apipie_organisation]
    @_apipie_user.assignments.build(keeper: @_apipie_user.organisations.first, role: BeachApiCore::Role.developer)
    @_apipie_user.valid?
    @_apipie_user
  end

  def apipie_asset
    return @_apipie_asset if @_apipie_asset
    @_apipie_asset = BeachApiCore::Asset.new(id: fake_id,
                                             file: Refile::FileDouble.new('dummy', 'logo.png', content_type: 'image/png'))
  end

  def apipie_entity
    @_apipie_entity ||= BeachApiCore::Entity.new(id: fake_id,
                                                 user: apipie_user,
                                                 uid: Faker::Crypto.md5,
                                                 kind: Faker::Lorem.word,
                                                 settings: { property: Faker::Lorem.word })
  end

  def apipie_favourite
    @_apipie_favourite ||= BeachApiCore::Favourite.new(id: fake_id,
                                                       user: apipie_user,
                                                       favouritable: apipie_asset)
  end

  def apipie_invitation
    @_apipie_invitation ||= BeachApiCore::Invitation.new(id: fake_id,
                                                         user: apipie_user,
                                                         invitee: apipie_user,
                                                         email: Faker::Internet.email,
                                                         group: apipie_team,
                                                         created_at: Time.now,
                                                         roles: [apipie_role])
  end

  def apipie_team
    @_apipie_team ||= BeachApiCore::Team.new(name: Faker::Company.name,
                                             application: apipie_oauth_application)
  end

  def apipie_organisation
    @_apipie_organisation ||= BeachApiCore::Organisation.new(id: fake_id,
                                                             name: Faker::Company.name,
                                                             application: apipie_oauth_application,
                                                             logo_image: apipie_asset,
                                                             logo_properties: { color: Faker::Color.hex_color })
  end

  def apipie_oauth_application
    @_oauth_application ||= Doorkeeper::Application.new(id: fake_id,
                                                        name: Faker::Company.name,
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

  def apipie_atom
    return @_apipie_atom if @_apipie_atom

    @_apipie_atom ||= BeachApiCore::Atom.new(id: fake_id,
                                             title: Faker::Name.title,
                                             kind: Faker::Lorem.word)
    @_apipie_atom.instance_variable_get(:@attributes)['atom_parent_id'] =
        ActiveRecord::Attribute.from_database('atom_parent_id', fake_id, ActiveModel::Type::Integer.new)
    @_apipie_atom
  end

  def apipie_role
    @_apipie_role ||= BeachApiCore::Role.new(id: fake_id,
                                             name: Faker::Lorem.word)
  end

  def apipie_assignment
    @_apipie_assignment ||= BeachApiCore::Assignment.new(id: fake_id, user: apipie_user,
                                                         role: apipie_role, keeper: apipie_organisation)
  end

  def apipie_setting
    @_apipie_setting ||= BeachApiCore::Setting.new(id: fake_id, keeper: apipie_organisation,
                                                   name: Faker::Name.title, value: Faker::Lorem.word)
  end

  def apipie_job
    @_apipie_job ||= BeachApiCore::Job.new(id: fake_id,
                                           start_at: 2.days.since,
                                           params: { headers: { 'Authorization' => "Bearer #{SecureRandom.hex}" },
                                                     method: %w(GET POST PUT PATCH DELETE).sample,
                                                     uri: '/uri',
                                                     input: { "#{Faker::Lorem.word}": Faker::Lorem.word } },
                                           result: { "#{Faker::Lorem.word}": Faker::Lorem.word })
  end

  def apipie_project
    @_apipie_project ||= BeachApiCore::Project.new(id: fake_id,
                                                   name: Faker::Name.title,
                                                   project_keepers: [apipie_project_keeper])
  end

  def apipie_project_keeper
    @_apipie_project_keeper ||= BeachApiCore::ProjectKeeper.new(id: fake_id,
                                                                keeper: apipie_instance)
  end

  def pretty(serializer)
    JSON.pretty_generate serializer.as_json
  end

  private

  def fake_id
    rand(1..100) * (-1)
  end
end

require 'refile/file_double'

module BeachApiCore::Concerns::V1::ApipieConcern
  def apipie_user
    return @_apipie_user if @_apipie_user
    @_apipie_user = BeachApiCore::User.new(id: fake_id, email: Faker::Internet.email)
    build_apipie_user_profile
    @_apipie_user.organisations = [apipie_organisation]
    @_apipie_user.teams = [apipie_team]
    @_apipie_user.assignments.build(keeper: @_apipie_user.organisations.first, role: BeachApiCore::Role.developer)
    @_apipie_user.assignments.build(keeper: @_apipie_user.teams.first, role: BeachApiCore::Role.developer)
    @_apipie_user.valid?
    @_apipie_user
  end

  def apipie_plan
    @_apipie_subscription_plan ||= BeachApiCore::Plan.new(id: fake_id,
                                                                      name: Faker::Name.title,
                                                                      stripe_id: Faker::Lorem.word,
                                                                      amount: Faker::Number.between(1000, 10000),
                                                                      interval: %w(day month year).sample,
                                                                      plan_for: %w(organisation user).sample,
                                                                      currency: "usd"
    )
  end

  def apipie_asset
    return @_apipie_asset if @_apipie_asset
    @_apipie_asset = BeachApiCore::Asset.new(id: fake_id,
                                             file: Refile::FileDouble.new('dummy', 'logo.png',
                                                                          content_type: 'image/png'))
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

  def apipie_user_channel
    { channel: 'UserChannel', id: fake_id.abs }
  end

  def apipie_entity_channel
    { channel: 'EntityChannel', id: fake_id.abs }
  end

  def apipie_interaction_attributes
    @_apipie_interaction_attributes ||= BeachApiCore::
            InteractionAttribute.new(id: fake_id,
                                     key: "#{Faker::Lorem.word}-#{Faker::Number.number(2)}",
                                     values: { text: Faker::Lorem.sentence })
  end

  def apipie_interaction_keeper
    @_apipie_interaction_keeper ||= BeachApiCore::InteractionKeeper.new(id: fake_id,
                                                                        keeper: apipie_entity)
  end

  def apipie_interaction
    @_apipie_interaction ||= BeachApiCore::Interaction.new(id: fake_id,
                                                           user: apipie_user,
                                                           kind: Faker::Lorem.word,
                                                           interaction_attributes: [apipie_interaction_attributes],
                                                           interaction_keepers: [apipie_interaction_keeper])
  end

  def apipie_invitation
    @_apipie_invitation ||= BeachApiCore::Invitation.new(id: fake_id,
                                                         user: apipie_user,
                                                         invitee: apipie_user,
                                                         email: Faker::Internet.email,
                                                         group: apipie_team,
                                                         created_at: Time.now.utc,
                                                         roles: [apipie_role])
  end

  def apipie_team
    @_apipie_team ||= BeachApiCore::Team.new( id: fake_id,
                                             name: Faker::Company.name,
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
    service_category = BeachApiCore::ServiceCategory.new(name: Faker::Job.title)
    @_apipie_service = service_category.services.build(title: Faker::Job.title,
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
                                             title: Faker::Job.title,
                                             kind: Faker::Lorem.word)
    @_apipie_atom
      .instance_variable_get(:@attributes)['atom_parent_id'] = ActiveRecord::Attribute
                                                               .from_database('atom_parent_id',
                                                                              fake_id,
                                                                              ActiveModel::Type::Integer.new)
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
                                                   name: Faker::Job.title, value: Faker::Lorem.word)
  end

  def apipie_mail_body
    @_apipie_mail_body ||= BeachApiCore::MailBody.new(id: fake_id, application_id: apipie_oauth_application.id,
                                                      mail_type: 0, body_text: body_text,
                                                      greetings_text: "DEAR [INVITEE_NAME],",
                                                      signature_text: "With Best Wishes \n [APPLICATION_NAME] Team",
                                                      footer_text: "©#{Time.now.year}, [APPLICATION_NAME] • All Rights Reserved")
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
                                                   name: Faker::Job.title,
                                                   project_keepers: [apipie_project_keeper])
  end

  def apipie_project_keeper
    @_apipie_project_keeper ||= BeachApiCore::ProjectKeeper.new(id: fake_id,
                                                                keeper: apipie_instance)
  end

  def apipie_webhook
    @_apipie_webhook ||= BeachApiCore::Webhook.new(id: fake_id,
                                                   keeper: apipie_oauth_application,
                                                   uri: Faker::Internet.url,
                                                   kind: BeachApiCore::Webhook.kinds.keys.first)
  end

  def apipie_chat
    @_apipie_chat ||= BeachApiCore::Chat.new(id: fake_id,
                                             users: [apipie_user],
                                             messages: [apipie_message])
  end

  def apipie_messages_user
    @_apipie_messages_user ||= BeachApiCore::Chat::MessagesUser.new(id: fake_id, user: apipie_user)
  end

  def apipie_message
    @_apipie_message ||= BeachApiCore::Chat::Message.new(id: fake_id,
                                                         messages_users: [apipie_messages_user],
                                                         message: Faker::Lorem.sentence,
                                                         sender: apipie_user)
  end

  def apipie_message_interaction_attributes
    @_apipie_interaction_attributes ||= BeachApiCore::InteractionAttribute.new(id: fake_id,
                                                                               key: 'message',
                                                                               values: { text: Faker::Lorem.sentence })
  end

  def apipie_message_interaction_keeper
    @_apipie_interaction_keeper ||= BeachApiCore::InteractionKeeper.new(id: fake_id,
                                                                        keeper: apipie_entity)
  end

  def apipie_device
    @_apipie_device ||= BeachApiCore::Device.new(id: fake_id, name: ["Macbook Pro", "Windows PC", "Linux Server"].sample)
  end

  def apipie_message_interaction
    @_apipie_message_interaction ||= BeachApiCore::
            Interaction.new(id: fake_id,
                            user: apipie_user,
                            kind: 'chat',
                            interaction_attributes: [apipie_message_interaction_attributes],
                            interaction_keepers: [apipie_message_interaction_keeper])
  end

  def apipie_notification
    @_apipie_notification ||= BeachApiCore::Notification.new(id: fake_id,
                                                             user: apipie_user,
                                                             message: "Project 'Awesome project' was created",
                                                             kind: 'email',
                                                             sent: false)
  end

  def pretty(serializer)
    JSON.pretty_generate serializer.as_json
  end

  private

  def fake_id
    rand(1..100)
  end

  def body_text
    "You have been invited to join [GROUP_NAME] \n
If you do not currently have an [APPLICATION_NAME] account, you will be given the opportunity to sign up,
 otherwise you can login and link your existing account to this organisation."
  end

  def build_apipie_user_profile
    @_apipie_user.build_profile(first_name: Faker::Name.first_name,
                                last_name: Faker::Name.last_name,
                                sex: BeachApiCore::Profile.sexes.keys.sample,
                                birth_date: Time.now.utc - rand(50 * 365).days,
                                avatar: apipie_asset)
  end
end

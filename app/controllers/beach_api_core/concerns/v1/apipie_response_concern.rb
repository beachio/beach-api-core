module BeachApiCore::Concerns::V1::ApipieResponseConcern
  include BeachApiCore::Concerns::V1::ApipieConcern

  private

  def apipie_user_response
    pretty BeachApiCore::UserSerializer.new(
      apipie_user, keepers: [BeachApiCore::Instance.current], host_url: "http://example.com", current_user: apipie_user
    ).as_json
  end

  def apipie_plan_response
    pretty BeachApiCore::PlanSerializer.new(apipie_plan)
  end

  def apipie_organisation_user_response
    pretty BeachApiCore::OrganisationUserSerializer.new(
      apipie_user, current_organisation: apipie_organisation
    ).as_json
  end

  def apipie_entity_response
    pretty BeachApiCore::EntitySerializer.new(apipie_entity)
  end

  def apipie_favourite_response
    pretty BeachApiCore::FavouriteSerializer.new(apipie_favourite)
  end

  def apipie_user_channel_response
    pretty apipie_user_channel
  end

  def apipie_entity_channel_response
    pretty apipie_entity_channel
  end

  def apipie_assignment_response
    pretty BeachApiCore::AssignmentSerializer.new(apipie_assignment)
  end

  def apipie_service_category_response
    pretty BeachApiCore::ServiceCategorySerializer.new(apipie_service_category)
  end

  def apipie_interaction_response
    pretty BeachApiCore::SimpleInteractionSerializer.new(apipie_interaction)
  end

  def apipie_invitation_response
    pretty BeachApiCore::InvitationSerializer.new(apipie_invitation)
  end

  def apipie_team_response
    pretty BeachApiCore::TeamSerializer.new(apipie_team, current_user: apipie_user)
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

  def apipie_setting_response
    pretty BeachApiCore::SettingSerializer.new(apipie_setting)
  end

  def apipie_mail_body_response
    pretty BeachApiCore::MailBodySerializer.new(apipie_mail_body)
  end

  def apipie_job_response
    pretty BeachApiCore::JobSerializer.new(apipie_job)
  end

  def apipie_project_response
    pretty BeachApiCore::ProjectSerializer.new(apipie_project)
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

  def apipie_webhook_response
    pretty BeachApiCore::WebhookSerializer.new(apipie_webhook)
  end

  def apipie_chat_response
    pretty BeachApiCore::ChatSerializer.new(apipie_chat)
  end

  def apipie_message_response
    pretty BeachApiCore::Chat::MessageSerializer.new(apipie_message)
  end

  def apipie_message_interaction_response
    pretty BeachApiCore::SimpleInteractionSerializer.new(apipie_message_interaction)
  end

  def apipie_device_response
    pretty BeachApiCore::DeviceSerializer.new(apipie_device)
  end

  def apipie_notification_response
    pretty BeachApiCore::NotificationSerializer.new(apipie_notification)
  end
end

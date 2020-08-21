module NotificationsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/notifications', I18n.t('api.resource_description.descriptions.notifications.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"notification\": [#{apipie_notification_response}, ...]"
  def index; end

  api :DELETE, '/notifications/:id', I18n.t('api.resource_description.descriptions.notifications.destroy')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"notification\": #{apipie_notification_response}"
  def destroy; end
end
module ScreensDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/screens/:id', I18n.t('api.resource_description.descriptions.screens.show')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param 'id', Integer, :desc => "Screen ID", required: true
  def show; end

  api :GET, '/screens/:id/next', I18n.t('api.resource_description.descriptions.screens.next')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param 'id', Integer, :desc => "Screen ID", required: true
  def next; end

  api :GET, '/screens/:id/prev', I18n.t('api.resource_description.descriptions.screens.prev')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param 'id', Integer, :desc => "Screen ID", required: true
  def prev; end

  api :GET, '/screens/flow', I18n.t('api.resource_description.descriptions.screens.flow')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param 'flow_id', Integer, :desc => "Flow ID", required: true
  def flow; end

  api :GET, '/screens/main_flow', I18n.t('api.resource_description.descriptions.screens.main_flow')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  def main_flow; end

end

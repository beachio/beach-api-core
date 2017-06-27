module BroadcastsDoc
  extend Apipie::DSL::Concern

  api :POST, '/broadcasts', I18n.t('api.resource_description.descriptions.broadcasts.create')
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  param :channel, Hash, required: true do
    param :name, String, required: true, desc: I18n.t('api.resource_description.descriptions.params.channel_name')
    param :id, Integer, required: true
    param :payload, Hash, required: true
  end
  example I18n.t('api.resource_description.fail',
                 description: I18n.t('api.resource_description.fails.errors_description'))
  def create_doc; end
end

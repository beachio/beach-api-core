class BeachApiCore::ElasticsearchIndexer
  include ::Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch'
  sidekiq_options retry: 10

  # Available options are:
  # - action: index or delete
  def perform(klass, id, opts = {})
    klass = klass.constantize
    return unless (entity = klass.find_by(id: id))

    opts.symbolize_keys!
    opts[:action] ||= 'index'
    elastic_opts = { index: klass.index_name, type: klass.document_type, id: entity.id }
    client = klass.__elasticsearch__.client

    case opts[:action]
    when 'index'
      client.index elastic_opts.merge(body: entity.as_indexed_json)
    when 'delete'
      client.delete elastic_opts
    else raise ArgumentError, t('errors.unknown_action', action: opts[:action])
    end
  end
end

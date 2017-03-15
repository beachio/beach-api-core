class BeachApiCore::ElasticsearchIndexer
  include ::Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch'
  sidekiq_options retry: 10

  # Available options are:
  # - action: index or delete
  # - serializer: serializer class to use instead of "as_indexed_json"
  def perform(klass, id, opts = {})
    klass = klass.constantize
    return unless (entity = klass.find_by(id: id))

    opts.symbolize_keys!
    opts[:action] ||= 'index'
    elastic_opts = { index: klass.index_name, type: klass.document_type, id: entity.id }
    client = klass.__elasticsearch__.client

    case opts[:action]
    when 'index'
      client.index elastic_opts.merge(body: serialized_entity(entity, opts[:serializer]))
    when 'delete'
      client.delete elastic_opts
    else raise ArgumentError, "Unknown action '#{opts[:action]}'"
    end
  end

  private

  def serialized_entity(entity, serializer = nil)
    return entity.as_indexed_json unless serializer
    serializer.constantize.new(entity).as_json
  end
end

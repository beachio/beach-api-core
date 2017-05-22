module BeachApiCore::Concerns::ElasticsearchIndexable
  extend ActiveSupport::Concern

  included do
    include ::Elasticsearch::Model

    after_commit :update_index, on: %i(create update), if: -> { ::BeachApiCore::Engine.elasticsearch_enabled }
    after_commit :destroy_index, on: :destroy, if: -> { ::BeachApiCore::Engine.elasticsearch_enabled }

    def as_indexed_json(options = {})
      return as_json(options.merge(root: false)) unless self.class.elasticserach_serializer_value
      self.class.elasticserach_serializer_value.new(self).as_json
    end

    private

    class << self
      def elasticsearch_serializer(klass_name)
        @_elasticserach_serializer = klass_name.constantize
      end

      def elasticserach_serializer_value
        @_elasticserach_serializer
      end
    end

    def update_index
      ::BeachApiCore::ElasticsearchIndexer.perform_async(self.class, id)
    end

    def destroy_index
      ::BeachApiCore::ElasticsearchIndexer.perform_async(self.class, id, action: 'delete')
    end
  end
end

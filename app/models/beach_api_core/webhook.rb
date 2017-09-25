module BeachApiCore
  class Webhook < ApplicationRecord
    belongs_to :application, class_name: 'Doorkeeper::Application'

    enum kind: { organisation_created: 0, team_created: 1, user_created: 2 }

    validates :uri, :kind, :application, presence: true

    class << self
      def notify(kind, entity_class, entity_id)
        BeachApiCore::WebhooksNotifier.perform_async(kind, entity_class, entity_id)
      end

      def class_to_kind(klass)
        kind = "#{klass.name.demodulize.downcase}_created"
        kind if kinds.keys.include?(kind)
      end
    end
  end
end

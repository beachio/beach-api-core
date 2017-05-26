module BeachApiCore
  class Webhook < ApplicationRecord
    belongs_to :application, class_name: 'Doorkeeper::Application'

    enum kind: { organisation_created: 0, team_created: 1, user_created: 2 }

    validates :uri, :kind, :application, presence: true

    class << self
      def notify(kind)
        BeachApiCore::WebhooksNotifier.perform_async(kind)
      end
    end
  end
end

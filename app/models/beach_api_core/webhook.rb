module BeachApiCore
  class Webhook < ApplicationRecord
    belongs_to :keeper, polymorphic: true
    enum kind: { organisation_created: 0,
                 team_created: 1,
                 user_created: 2,
                 organisation_deleted: 3,
                 scores_achieved: 4
               }

    validates :uri, :kind, :keeper, presence: true
    attr_accessor :scores
    validate :validate_params

    def validate_params
      if kind == 'scores_achieved'
        valid = scores.is_a?(Integer) ? true : !scores.match(/\A\d*\z/).nil?
        self.errors.add :scores, "wrong. Scores should be more then 0"  if scores.nil? || !valid
        self.parametrs = "{\"scores\": #{scores}}"
      else
        self.parametrs = "{}"
      end
    end

    class << self
      def notify(kind, entity_class, entity_id, doorkeeper_token_id = nil, parametrs = nil)
        BeachApiCore::WebhooksNotifier.perform_async(kind, entity_class, entity_id, doorkeeper_token_id, parametrs)
      end

      def class_to_kind(klass, event)
        kind = "#{klass.name.demodulize.downcase}_#{event}"
        kind if kinds.keys.include?(kind)
      end
    end
  end
end

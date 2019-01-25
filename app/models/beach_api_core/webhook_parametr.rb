module BeachApiCore
  class WebhookParametr < ActiveRecord::Base
    belongs_to :webhook_config, class_name: "BeachApiCore::WebhookConfig"
    validates :name, :value, presence: true
  end
end

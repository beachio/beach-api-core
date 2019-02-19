module BeachApiCore
  class WebhookConfig < ActiveRecord::Base
    belongs_to :application, class_name: "Doorkeeper::Application"
    has_many :webhook_parametrs, class_name: "BeachApiCore::WebhookParametr", dependent: :destroy
    has_many :achievements, class_name: "BeachApiCore::Achievement", as: :mode, dependent: :destroy
    has_many :rewards, through: :achievements
    accepts_nested_attributes_for :webhook_parametrs, allow_destroy: true

    validates  :config_name, uniqueness: { scope: :application }
    validates :config_name, :application_id, :uri, :request_method, presence: true
    validate :check_webhook_on_params, on: :create
    attr_readonly :application_id
    enum request_method: {
        "GET" => 0,
        "POST" => 1,
        "PUT" => 2,
        "DELETE" => 3
    }
    private

    def check_webhook_on_params
      self.errors.add :request_body, "Request body should have valid json format" if !self.request_body.nil? && !self.request_body.empty? && !valid_json?(self.request_body) && request_method != "GET"
    end

    def valid_json?(json)
      JSON.parse(json)
      return true
    rescue JSON::ParserError => e
      return false
    end
  end
end

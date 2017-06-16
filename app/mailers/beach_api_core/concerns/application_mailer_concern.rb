module BeachApiCore::Concerns::ApplicationMailerConcern
  extend ActiveSupport::Concern

  included do
    private

    def from(kind)
      BeachApiCore::Setting.send(kind, keeper: @application)
    end

    def client_url(path)
      URI.join(BeachApiCore::Setting.client_domain(keeper: @application), path).to_s
    end
  end
end

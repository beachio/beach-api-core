module BeachApiCore::Concerns::ApplicationMailerConcern
  extend ActiveSupport::Concern

  included do
    private

    def from(kind)
      BeachApiCore::Setting.send(kind, keeper: @application)
    end

    def client_url(path, query = {})
      URI.join(BeachApiCore::Setting.client_domain(keeper: @application), path,
               "#{'?' if query.present?}#{URI.encode_www_form(query)}").to_s
    end
  end
end

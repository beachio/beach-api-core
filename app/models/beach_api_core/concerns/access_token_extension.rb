module BeachApiCore::Concerns::AccessTokenExtension
  extend ActiveSupport::Concern

  included do
    belongs_to :organisation, class_name: 'BeachApiCore::Organisation'
    belongs_to :user, class_name: 'BeachApiCore::User', foreign_key: :resource_owner_id

    class << self
      def revoke_all_for(application_id, resource_owner, organisation = nil)
        where(application_id: application_id,
              organisation_id: organisation&.id,
              resource_owner_id: resource_owner.id,
              revoked_at: nil).find_each(&:revoke)
      end

      def matching_token_for(application, resource_owner_or_id, scopes, organisation_id = nil)
        organisation_id = if organisation_id.respond_to?(:to_key)
                            organisation_id.id
                          else
                            organisation_id
                          end
        resource_owner_id = if resource_owner_or_id.respond_to?(:to_key)
                              resource_owner_or_id.id
                            else
                              resource_owner_or_id
                            end
        token = last_authorized_token_for(application.try(:id), resource_owner_id, organisation_id)
        if token && scopes_match?(token.scopes, scopes, application.try(:scopes))
          token
        end
      end

      def find_or_create_for(application, resource_owner_id, scopes, expires_in, use_refresh_token, organisation_id = nil)
        if Doorkeeper.configuration.reuse_access_token
          access_token = matching_token_for(application, resource_owner_id, scopes, organisation_id)
          if access_token && !access_token.expired?
            return access_token
          end
        end

        create!(
          application_id:    application.try(:id),
          organisation_id:   organisation_id,
          resource_owner_id: resource_owner_id,
          scopes:            scopes.to_s,
          expires_in:        expires_in,
          use_refresh_token: use_refresh_token
        )
      end

      def last_authorized_token_for(application_id, resource_owner_id, organisation_id = nil)
        send(order_method, created_at_desc).
            find_by(application_id: application_id,
                    organisation_id: organisation_id,
                    resource_owner_id: resource_owner_id,
                    revoked_at: nil)
      end
    end

    def as_json(_options = {})
      {
        organisation_id:    organisation_id,
        resource_owner_id:  resource_owner_id,
        scopes:             scopes,
        expires_in_seconds: expires_in_seconds,
        application:        { uid: application.try(:uid) },
        created_at:         created_at.to_i
      }
    end

    def same_credential?(access_token)
      application_id == access_token.application_id &&
        organisation_id == access_token.organisation_id &&
        resource_owner_id == access_token.resource_owner_id
    end

    def generate_token
      self.created_at ||= Time.now.utc

      generator = Doorkeeper.configuration.access_token_generator.constantize
      self.token = generator.generate(
        resource_owner_id: resource_owner_id,
        organisation_id: organisation_id,
        scopes: scopes,
        application: application,
        expires_in: expires_in,
        created_at: created_at
      )
    rescue NoMethodError
      raise Errors::UnableToGenerateToken, "#{generator} does not respond to `.generate`."
    rescue NameError
      raise Errors::TokenGeneratorNotFound, "#{generator} not found"
    end
  end
end

module BeachApiCore::Concerns::OrganisationRestrictionMailerConcern
  extend ActiveSupport::Concern

  included do
    after_action :check_organisation_restriction

    private

    def check_organisation_restriction
      mail.perform_deliveries = false if @organisation && !@organisation.send_email
    end
  end
end

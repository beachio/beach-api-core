module BeachApiCore
  class ApplicationMailer < ActionMailer::Base
    include BeachApiCore::Concerns::OrganisationRestrictionMailerConcern
    include BeachApiCore::Concerns::ApplicationMailerConcern

    add_template_helper(BeachApiCore::Concerns::ApplicationMailerConcern)
    layout 'mailer'
  end
end

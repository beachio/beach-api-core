module BeachApiCore
  class ApplicationMailer < ActionMailer::Base
    include BeachApiCore::Concerns::OrganisationRestrictionMailerConcern
    include BeachApiCore::Concerns::ApplicationMailerConcern

    add_template_helper(BeachApiCore::Concerns::ApplicationMailerConcern)
    BeachApiCore.configure if  BeachApiCore.company_names.nil?
    layout 'mailer'
  end
end

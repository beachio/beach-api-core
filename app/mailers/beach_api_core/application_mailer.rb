module BeachApiCore
  class ApplicationMailer < ActionMailer::Base
    include BeachApiCore::Concerns::OrganisationRestrictionMailerConcern

    default from: 'from@example.com'
    layout 'mailer'
  end
end

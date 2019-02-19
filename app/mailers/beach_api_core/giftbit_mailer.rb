module BeachApiCore
  class GiftbitMailer < ApplicationMailer

    def not_enough_balance(profile)
      email = profile.giftbit_token.blank? ? BeachApiCore::Setting.giftbit_admin(keeper: BeachApiCore::Instance.current) :
          profile.email_to_notify
      @application = profile.application
      unless email.blank?
        mail(to: email,
             subject: "Not enough balance for #{profile.config_name} config for #{profile.application.name}")
      end
    end

    def campaign_creation_error profile, error
      @error = error
      @profile = profile
      @application = profile.application
      email = profile.giftbit_token.blank?? BeachApiCore::Setting.giftbit_admin(keeper: BeachApiCore::Instance.current) :
          profile.email_to_notify
      unless email.blank?
        mail(to: email,
             subject: "Failed to create campaign for #{profile.config_name} for #{profile.application.name}")
      end
    end
  end
end
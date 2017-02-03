module BeachApiCore::Concerns::UserConfirm
  extend ActiveSupport::Concern

  included do
    def confirm_email_token
      verifier = self.class.verifier_for('confirm-email')
      verifier.generate(email)
    end

    def confirm_email!(token)
      user_email = self.class.verifier_for('confirm-email').verify(token)
      update_attribute(:confirmed_at, Time.zone.now) if user_email == email
      user_email == email
    end
  end

  class_methods do
    def verifier_for(purpose)
      @verifiers ||= {}
      @verifiers.fetch(purpose) { |p| @verifiers[p] = Rails.application.message_verifier("#{name}-#{p}") }
    end
  end

end
module BeachApiCore::UserInteractor
  class AuthenticateApplication
    include Interactor

    def call
      if context.headers.present?
        application_id, application_secret = context.headers.split(',')
        application_id.gsub!('application_id', '').to_s.strip!
        application_secret.gsub!('client_secret', '').to_s.strip!
        application = Doorkeeper::Application.find_by(uid: application_id)

        if application.blank? || application.secret != application_secret
          context.status = :unauthorized
          context.fail! message: [t('interactors.errors.incorrect_application_id_or_secret')]
        end
        context.application = application
        context.application_id = application.id
      elsif !context.skip_headers
        context.status = :unauthorized
        context.fail! message: [t('interactors.errors.require_application_id_and_secret')]
      end
    end
  end
end

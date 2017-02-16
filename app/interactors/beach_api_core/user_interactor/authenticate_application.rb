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
          context.fail! message: ['Application ID and/or secret are not correct']
        end
        context.application = application
        context.application_id = application.id
      end
    end
  end
end

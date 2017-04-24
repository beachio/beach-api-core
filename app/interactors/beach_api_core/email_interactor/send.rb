module BeachApiCore
  module EmailInteractor
    class Send
      include Interactor::Organizer

      organize [BeachApiCore::UserInteractor::AuthenticateApplication,
                BeachApiCore::EmailInteractor::Create]
    end
  end
end

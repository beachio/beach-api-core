module BeachApiCore
  module JobsInteractor
    class Show
      include Interactor::Organizer

      organize [BeachApiCore::UserInteractor::AuthenticateApplication,
                BeachApiCore::ValidateApplication]
    end
  end
end

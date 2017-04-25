module BeachApiCore
  module JobsInteractor
    class Submit
      include Interactor::Organizer

      organize [BeachApiCore::UserInteractor::AuthenticateApplication,
                BeachApiCore::ValidateApplication,
                BeachApiCore::JobsInteractor::Create]
    end
  end
end

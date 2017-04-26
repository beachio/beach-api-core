module BeachApiCore
  module JobsInteractor
    class Cancel
      include Interactor::Organizer

      organize [BeachApiCore::UserInteractor::AuthenticateApplication,
                BeachApiCore::ValidateApplication,
                BeachApiCore::JobsInteractor::Destroy]
    end
  end
end

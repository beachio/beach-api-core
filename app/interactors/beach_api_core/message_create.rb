class BeachApiCore::MessageCreate
  include Interactor::Organizer

  organize [BeachApiCore::MessageInteractor::Create,
            BeachApiCore::MessageInteractor::Broadcast]
end

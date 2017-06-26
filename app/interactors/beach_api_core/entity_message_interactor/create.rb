module BeachApiCore::EntityMessageInteractor
  class Create
    include Interactor::Organizer

    organize [BeachApiCore::InteractionCreate,
              BeachApiCore::EntityBroadcastSend]
  end
end

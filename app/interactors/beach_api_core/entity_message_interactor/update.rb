module BeachApiCore::EntityMessageInteractor
  class Update
    include Interactor::Organizer

    organize [BeachApiCore::InteractionUpdate,
              BeachApiCore::EntityBroadcastSend]
  end
end

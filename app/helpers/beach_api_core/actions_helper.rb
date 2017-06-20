module BeachApiCore
  module ActionsHelper
    def controllers
      BeachApiCore::ActionPermissions.controllers
    end

    def actions(controller)
      BeachApiCore::ActionPermissions.actions(controller)
    end
  end
end

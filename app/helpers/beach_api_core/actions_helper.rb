module BeachApiCore
  module ActionsHelper
    def controllers
      BeachApiCore::ActionsPermissions.controllers
    end

    def actions(controller)
      BeachApiCore::ActionsPermissions.actions(controller)
    end
  end
end

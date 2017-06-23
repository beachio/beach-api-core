module BeachApiCore::Concerns::ActionPermissionsConcern
  extend ActiveSupport::Concern

  included do
    before_action :check_action_permissions!

    def check_action_permissions!
      return unless current_application
      controller_classname = self.class.name

      controllers_with_action = BeachApiCore::Controller.with_action(controller_classname, action_name).select(:id)
      controllers_without_actions = BeachApiCore::Controller.without_actions(controller_classname).select(:id)

      has_action_permissions = current_application.services.joins(:controllers).where.has do
        controllers.id.in(controllers_with_action) | controllers.id.in(controllers_without_actions)
      end.exists?

      return true if has_action_permissions
      render_json_error(I18n.t('api.errors.have_no_permissions'), :forbidden)
    end
  end
end

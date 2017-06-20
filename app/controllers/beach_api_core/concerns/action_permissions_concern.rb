module BeachApiCore::Concerns::ActionPermissionsConcern
  extend ActiveSupport::Concern

  included do
    before_action :check_action_permissions!

    def check_action_permissions!
      return unless current_application
      controller_classname = self.class.name

      controllers_with_actions =
        BeachApiCore::Controller.joins(:actions).where(name: controller_classname,
                                                       beach_api_core_actions: { name: action_name }).select(:id)
      controllers_without_actions =
        BeachApiCore::Controller.left_outer_joins(:actions).group(:id, :name)
                                .having(name: controller_classname)
                                .having('COUNT(beach_api_core_actions.*) = 0').select(:id)

      has_action_permissions = current_application.services.joins(:controllers).where.has do |services|
        services.id.in(controllers_with_actions) | services.id.in(controllers_without_actions)
      end.exists?

      return true if has_action_permissions
      render_json_error(I18n.t('api.errors.have_no_permissions'), :forbidden)
    end
  end
end

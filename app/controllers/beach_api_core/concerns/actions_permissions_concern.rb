module BeachApiCore::Concerns::ActionsPermissionsConcern
  extend ActiveSupport::Concern

  included do
    before_action :check_action_permissions!

    def check_action_permissions!
      return unless current_application

      controllers_with_actions =
        BeachApiCore::ControllersService.joins(:actions_controllers)
                                        .where(name: controller_name,
                                               beach_api_core_actions_controllers: { name: action_name }).select(:id)
      controllers_without_actions =
        BeachApiCore::ControllersService.left_outer_joins(:actions_controllers).group(:id, :name)
                                        .having(name: controller_name)
                                        .having('COUNT(beach_api_core_actions_controllers.*) = 0').select(:id)

      has_action_permissions =
        current_application.services.joins(:controllers_services).where(<<SQL).exists?
  beach_api_core_controllers_services.id IN (#{controllers_with_actions.to_sql}) OR
  beach_api_core_controllers_services.id IN (#{controllers_without_actions.to_sql})
SQL

      return if has_action_permissions
      render_json_error(I18n.t('api.errors.have_no_permissions'), :forbidden)
    end
  end
end

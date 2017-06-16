module BeachApiCore
  class ActionsPermissions
    FILTERED_CONTROLLERS = %w(ApplicationController BeachApiCore::ApplicationController BeachApiCore::V1::BaseController
                              BeachApiCore::V1::ApplicationsController
                              Inventions::ApplicationController Inventions::V1::BaseController
                              Patents::ApplicationController Patents::V1::ApplicationsController
                              Patents::V1::BaseController).freeze
    FILTERED_CONTROLLER_PREFIXES = %w(ActiveAdmin:: Admin:: Doorkeeper:: Apipie:: InheritedResources::).freeze

    class << self
      def controllers
        filter_controllers ActionController::Base.descendants.map(&:to_s)
      end

      def actions(controller)
        controller.constantize.action_methods.to_a - pundit_methods
      end

      def grant_permissions!(application)
        service_category = BeachApiCore::ServiceCategory.new(name: 'Main')
        service = Service.new(title: 'Grant', service_category: service_category)
        BeachApiCore::ActionsPermissions.controllers.each do |controller_name|
          service.controllers_services.build(name: controller_name)
        end
        application.capabilities.build(service: service)
        application.save
      end

      private

      def filter_controllers(controllers)
        (controllers - FILTERED_CONTROLLERS).reject do |controller|
          FILTERED_CONTROLLER_PREFIXES.any? { |prefix| controller.start_with?(prefix) }
        end
      end

      def pundit_methods
        blank_slate = Class.new
        blank_slate.instance_methods.each { |method| blank_slate.instance_eval { undef_method method } }
        blank_slate.instance_eval { include Pundit }
        blank_slate.instance_methods.map(&:to_s)
      end
    end
  end
end

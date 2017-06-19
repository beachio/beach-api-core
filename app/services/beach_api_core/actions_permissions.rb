module BeachApiCore
  class ActionsPermissions
    class << self
      def controllers
        filter_controllers ActionController::Base.descendants.map(&:to_s)
      end

      def actions(controller)
        controller.constantize.action_methods.to_a - pundit_methods
      end

      def grant_permissions!(application)
        service_category = BeachApiCore::ServiceCategory.new(name: BeachApiCore.grant_service_category_name)
        service = BeachApiCore::Service.new(title: BeachApiCore.grant_service_name, service_category: service_category)
        BeachApiCore::ActionsPermissions.controllers.each do |controller_name|
          service.controllers_services.build(name: controller_name)
        end
        capability = application.capabilities.build(service: service)
        capability.save
      end

      private

      def filter_controllers(controllers)
        (controllers - BeachApiCore.filtered_controllers).reject do |controller|
          BeachApiCore.filtered_controller_prefixes.any? { |prefix| controller.start_with?(prefix) }
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

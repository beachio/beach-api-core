def grant_permission!(application, controller_name, action_name = nil)
  service_category = BeachApiCore::ServiceCategory.new(name: 'Main')
  service = BeachApiCore::Service.new(title: 'Grant', service_category: service_category)

  controller = service.controllers.build(name: controller_name)
  controller.actions.build(name: action_name) if action_name

  capability = application.capabilities.build(service: service)
  capability.save
end

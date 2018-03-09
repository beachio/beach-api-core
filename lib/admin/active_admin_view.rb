module ActiveAdmin::Views
  class ActiveAdminForm
    def screens method, args={}
      html = ApplicationController.render(
        :template => 'beach_api_core/active_admin/screens/app',
        :locals => {
          screens: object.screens,
          initial_screen: object.initial_screen,
          name: "#{object_name}[#{method}]"
        }
      )
      insert_tag ScreensBuilder, html.html_safe
    end
  end

  class ScreensBuilder < ActiveAdmin::Component
    def build(options = {})
      super(options)
    end
  end
end
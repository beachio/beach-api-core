module ActiveAdmin::Views
  class ActiveAdminForm
    def screens method, args={}
      html = ApplicationController.render(
        :template => 'beach_api_core/active_admin/screens/app',
        :locals => {
          screens: object.screens,
          object_name: object_name,
          name: "#{object_name}[#{method}]"
        }
      )
      insert_tag ScreensBuilder, html.html_safe
    end

  end
end
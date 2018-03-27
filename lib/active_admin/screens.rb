module ActiveAdmin
  class Screens
    @app_components = ["beach_api_core/screens/components"]
    @active_admin_components = ["beach_api_core/active_admin/screens/components"]
    @app_js_pathes = ["screens/components"]
    @app_css_pathes = ["screens/app"]
    @active_admin_js_pathes = ["active_admin/screens/app"]
    @active_admin_css_pathes = ["active_admin/screens/app"]
    @body_controls = {
        content: ["card", "items-in-a-row", 'combination-control'],
        forms: ["checkbox-list", "radio-list", "input", "button"],
        "graphical-elements": ["video", "image"],
        "data-visualization": ["chart"]
    }
    @footer_controls = {
        forms: ['button', 'input', 'select']
    }

    class << self
      attr_accessor :app_js_pathes,
                    :app_css_pathes,
                    :active_admin_js_pathes,
                    :active_admin_css_pathes,
                    :body_controls,
                    :footer_controls,
                    :app_components,
                    :active_admin_components
    end
  end
end
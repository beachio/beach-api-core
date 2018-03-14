module ActiveAdmin
  class Screens
    @app_js_pathes = ["screens/app"]
    @app_css_pathes = ["screens/app"]
    @active_admin_js_pathes = ["active_admin/screens/app"]
    @active_admin_css_pathes = ["active_admin/screens/app"]
    @body_controls = ['checkbox-list', 'radio-list', 'image', 'video', 'chart']
    @footer_controls = ['button', 'input', 'select']

    class << self
      attr_accessor :app_js_pathes,
                    :app_css_pathes,
                    :active_admin_js_pathes,
                    :active_admin_css_pathes,
                    :body_controls,
                    :footer_controls
    end
  end
end
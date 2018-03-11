require_relative "open_in_mobile"
module ActiveAdmin
  module Views
    class IndexAsDirectoriesGrid < IndexAsBlock
      include ActiveAdmin::Views::OpenInMobile

      def directories_grid
        html = ApplicationController.render(
          :template => 'beach_api_core/active_admin/directories/app'
        )
        insert_tag ScreensBuilder, html.html_safe
      end

      def build(page_presenter, collection)
        add_class "index"
        resource_selection_toggle_panel if active_admin_config.batch_actions.any?
        instance_exec(collection.first, &page_presenter.block)
      end

      def self.index_name
        "Directories"
      end
    end
  end
end
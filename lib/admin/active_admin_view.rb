module OpenInMobile
  def open_in_mobile screen
    return unless screen
    content = <<-HTML
      <style>
        .open_in_mobile {
          padding: 5px 15px;
          text-decoration: none;
          cursor: pointer;
          display: inline-block;
          background: #5e0966;
          color: white;
          font-size: 16px;
          border-radius: 5px;
        }
        .open_in_mobile:hover {
          background: #860892;
        }
      </style>
      <a onclick="window.open('/screens/#{screen.id}/view','mobile_window','width=375,height=680,resizable=no');" class="open_in_mobile">Open in mobile</a>
    HTML
    insert_tag ActiveAdmin::Views::OpenInMobileBtn, content.html_safe
  end
end

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

  class Pages::Show
    include OpenInMobile
  end

  class IndexAsBlock
    include OpenInMobile

    def directories_grid
      html = ApplicationController.render(
        :template => 'beach_api_core/active_admin/directories/app'
      )
      insert_tag ScreensBuilder, html.html_safe
    end
  end


  class IndexAsDirectoriesGrid < IndexAsBlock
    def build(page_presenter, collection)
      add_class "index"
      resource_selection_toggle_panel if active_admin_config.batch_actions.any?
      instance_exec(collection.first, &page_presenter.block)
    end

    def self.index_name
      "Directories"
    end
  end

  class DirectoryGridClass
    def build(options = {})
      super(options)
    end
  end

  class ScreensBuilder < ActiveAdmin::Component
    def build(options = {})
      super(options)
    end
  end

  class OpenInMobileBtn < ActiveAdmin::Component
    def build(options = {})
      super(options)
    end
  end
end
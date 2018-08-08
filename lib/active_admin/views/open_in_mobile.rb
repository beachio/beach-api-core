module ActiveAdmin::Views::OpenInMobile
  def open_in_mobile bot
    return unless bot
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
      <a onclick="window.open('/screens/view?bot_uuid=#{bot.uuid}','mobile_window','width=375,height=680,resizable=no');" class="open_in_mobile">Open in mobile</a>
    HTML
    insert_tag ActiveAdmin::Views::OpenInMobileBtn, content.html_safe
  end
end
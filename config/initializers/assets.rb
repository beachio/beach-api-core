# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( beach_api_core/mailer/team-background.jpg
                                                  beach_api_core/mailer/icon-help.png
                                                  beach_api_core/mailer/organisation-background.jpg
                                                  beach_api_core/mailer/account-background.jpg
                                                  beach_api_core/mobile_header.png
                                                  beach_api_core/folder-closed.png
                                                  beach_api_core/file.png
                                                  screens.js
                                                  screens.scss
                                                  )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( beach_api_core/mailer/team-background.jpg beach_api_core/mailer/icon-help.png
                                                  beach_api_core/mailer/organisation-background.jpg
                                                  beach_api_core/mailer/account-background.jpg )

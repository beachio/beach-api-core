class BeachApiCore::Authorization::CreateAccessToken
  include Interactor

  def call
    if context.application
      context.access_token = Doorkeeper::AccessToken.find_or_create_for(context.application,
                                                                        context.user.id,
                                                                        'password',
                                                                        Doorkeeper.configuration.access_token_expires_in,
                                                                        Doorkeeper.configuration.refresh_token_enabled?)
      if context.access_token
        context.status = :ok
      else
        context.status = :unauthorized
      end
    end
  end

end


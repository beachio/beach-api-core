module BeachApiCore
  class BroadcastSend
    include Interactor

    def call
      klass = context.params[:name].gsub(/Channel/, '')
      channel = "BeachApiCore::#{context.params[:name]}".constantize
      object = "BeachApiCore::#{klass}".constantize.find(context.params[:id]) if "BeachApiCore::#{klass}" == "BeachApiCore::User" || "BeachApiCore::#{klass}" == "BeachApiCore::Entity"
      if "BeachApiCore::#{klass}" == "BeachApiCore::User"
        token = Doorkeeper::AccessToken.find_or_create_for(context.application,
                                                           object.id,
                                                           Doorkeeper::OAuth::Scopes.from_string('password'),
                                                           Doorkeeper.configuration.access_token_expires_in,
                                                           Doorkeeper.configuration.refresh_token_enabled?)
        channel.broadcast_to(token, payload: context.params[:payload], :user => BeachApiCore::UserSerializer.new(object, root: :user))
      elsif "BeachApiCore::#{klass}" == "BeachApiCore::Application"
        channel.broadcast_to(context.application, payload: context.params[:payload], klass.underscore => context.application)
      else
        channel.broadcast_to(object, payload: context.params[:payload], klass.underscore => object)
      end
      context.status = :created
    end
  end
end

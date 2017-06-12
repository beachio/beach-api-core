module BeachApiCore
  class BroadcastSend
    include Interactor

    def call
      klass = context.params[:name].gsub(/Channel/, '')
      channel = "BeachApiCore::#{context.params[:name]}".constantize
      object = "BeachApiCore::#{klass}".constantize.find(context.params[:id])

      channel.broadcast_to(object, payload: context.params[:payload], klass.underscore => object)
      context.status = :created
    end
  end
end

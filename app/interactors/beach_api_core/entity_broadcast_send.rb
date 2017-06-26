class BeachApiCore::EntityBroadcastSend
  include Interactor

  def call
    BeachApiCore::EntityChannel.broadcast_to(context.entity,
                                             entity: context.entity,
                                             payload: { name: 'new_comment_notification',
                                                        message: context.message_text })
    context.status = :ok
  end
end

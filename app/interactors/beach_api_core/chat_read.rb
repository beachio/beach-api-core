class BeachApiCore::ChatRead
  include Interactor

  def call
    BeachApiCore::Chat::MessagesUser.joins(:message).merge(context.chat.messages).update_all(read: true)
    context.chat.reload
    context.status = :ok
  end
end

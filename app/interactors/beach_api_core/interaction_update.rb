class BeachApiCore::InteractionUpdate
  include Interactor

  def call
    message_interaction_attribute.values['text'] = context.message_text
    if message_interaction_attribute.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.interaction.errors.full_messages
    end
  end

  def message_interaction_attribute
    @_message_interaction_attribute ||= context.interaction.interaction_attributes.find_by!(key: 'message')
  end
end

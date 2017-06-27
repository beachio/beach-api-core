class BeachApiCore::InteractionUpdate
  include Interactor

  before do
    context.message_interaction_attribute ||= context.interaction.interaction_attributes.find_by!(key: 'message')
  end

  def call
    context.message_interaction_attribute.values['text'] = context.message_text
    if context.message_interaction_attribute.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.interaction.errors.full_messages
    end
  end
end

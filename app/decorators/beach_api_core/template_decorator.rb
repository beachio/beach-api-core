class BeachApiCore::TemplateDecorator < Draper::Decorator
  delegate_all

  def pretty_value(interaction)
    return '' unless interaction
    ::BeachApiCore::TemplateParser.new(object, interaction: interaction).call
  end
end

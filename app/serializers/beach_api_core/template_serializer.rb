module BeachApiCore
  class TemplateSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::OptionSerializerConcern
    acts_with_options(:interaction)
    attributes :value

    def value
      object.decorate.pretty_value(interaction)
    end

    def interaction
      instance_options[:interaction]
    end
  end
end

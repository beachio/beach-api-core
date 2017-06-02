module BeachApiCore
  class TemplateSerializer < ActiveModel::Serializer
    attributes :value

    def value
      object.decorate.pretty_value(interaction)
    end

    def interaction
      instance_options[:interaction]
    end
  end
end

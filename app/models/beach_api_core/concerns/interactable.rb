module BeachApiCore::Concerns::Interactable
  extend ActiveSupport::Concern

  included do
    attr_accessor :current_user

    before_save :create_interaction, unless: 'new_record?'

    private

    def create_interaction
      return unless self.class.interactable_attrs && current_user
      self.class.interactable_attrs.each do |attr|
        next unless send(:"#{attr}_changed?")
        kind = "#{attr}_changed"
        interactions.create(kind: kind, user: current_user,
                            interaction_attributes_attributes: [{ key: 'new_value',
                                                                  values: { value: send(attr) } }])
      end
    end

    class << self
      def acts_as_interactable_on(*attrs)
        @_interactable_attrs = attrs
      end

      def interactable_attrs
        @_interactable_attrs
      end
    end
  end
end

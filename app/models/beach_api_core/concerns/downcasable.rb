module BeachApiCore::Concerns::Downcasable
  extend ActiveSupport::Concern

  class_methods do
    def acts_as_downcasable_on(attributes = [])
      before_validation do
        attributes.each do |attribute|
          send(attribute).downcase! if send(attribute).present?
        end
      end
    end
  end
end

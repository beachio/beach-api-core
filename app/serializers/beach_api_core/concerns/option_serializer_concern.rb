module BeachApiCore::Concerns::OptionSerializerConcern
  extend ActiveSupport::Concern

  class_methods do
    def acts_with_options(*args)
      instance_eval do
        args.each do |attr|
          define_method attr do
            instance_options[attr.to_sym]
          end
        end
      end
    end
  end
end

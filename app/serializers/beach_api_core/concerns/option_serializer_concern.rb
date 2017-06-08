module BeachApiCore::Concerns::OptionSerializerConcern
  extend ActiveSupport::Concern

  class_methods do
    def acts_with_options(*args)
      instance_eval do
        args.each do |attr|
          define_method attr do
            puts "#{instance_options[attr.to_sym].inspect} -- #{attr.inspect}"
            instance_options[attr.to_sym]
          end

          private attr
        end
      end
    end
  end
end

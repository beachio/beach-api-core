module BeachApiCore::Concerns::DocIdAbsSerializerConcern
  extend ActiveSupport::Concern

  class_methods do
    def acts_as_abs_doc_id(*args)
      instance_eval do
        args = [:id] if args.blank?
        args.each do |attr|
          define_method attr do
            object.send(attr).abs if object.send(attr)
          end
        end
      end
    end
  end
end
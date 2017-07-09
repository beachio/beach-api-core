module BeachApiCore::Concerns::V1::AliasBaseConcern
  extend ActiveSupport::Concern

  class_methods do
    def methods_with_base_alias(*args)
      instance_eval do
        args.each do |attr|
          alias_method "base_#{attr}".to_sym, attr
        end
      end
    end
  end
end

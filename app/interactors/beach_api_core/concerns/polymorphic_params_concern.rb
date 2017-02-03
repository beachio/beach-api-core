module BeachApiCore::Concerns::PolymorphicParamsConcern
  extend ActiveSupport::Concern

  included do
    private

    def normalize_polymorphic_class(params)
      params.each do |key, value|
        next unless key.to_s.match(/\A.*_type\z/)
        params[key] = "BeachApiCore::#{value}"
      end
    end
  end
end

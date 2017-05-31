module BeachApiCore::Concerns::PolymorphicParamsConcern
  extend ActiveSupport::Concern

  included do
    private

    def normalize_polymorphic_class(params)
      params.each do |key, value|
        next unless /\A.*_type\z/.match?(key.to_s)
        params[key] = "BeachApiCore::#{value}" unless /\ABeachApiCore::/.match?(value)
      end
    end
  end
end

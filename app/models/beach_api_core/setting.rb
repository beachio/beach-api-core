module BeachApiCore
  class Setting < ApplicationRecord
    validates :name, :keeper, :value, presence: true
    validates :name, uniqueness: { scope: %i(keeper_id keeper_type) }
    validate :allowed_name
    before_save :normalize_name

    belongs_to :keeper, polymorphic: true

    class << self
      def method_missing(name, *args, &block)
        super
      rescue NoMethodError
        keeper = args.any? ? (args.first[:keeper] || BeachApiCore::Instance.current) : BeachApiCore::Instance.current
        setting = Setting.find_by(name: name, keeper: keeper)
        return setting.value if setting
      end

      def respond_to_missing?(method_name, include_private = false)
        super || (method_name.match(/^(?!define_method).*$/) && where(name: method_name).present?)
      end
    end

    private

    def allowed_name
      errors.add(:name, :not_allowed) if name && Setting.methods.include?(name.to_sym)
    end

    def normalize_name
      self.name = name.parameterize(separator: '_')
    end
  end
end

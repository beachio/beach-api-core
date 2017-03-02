module BeachApiCore
  class Setting < ApplicationRecord
    validates :key, :keeper, presence: true
    validates :key, uniqueness: { scope: [:keeper_id, :keeper_type] }
    validate :allowed_key
    belongs_to :keeper, polymorphic: true

    class << self
      def method_missing(name, *args, &block)
        super
      rescue NoMethodError
        keeper = args.any? ? (args.first[:keeper] || BeachApiCore::Instance.current) : BeachApiCore::Instance.current
        setting = Setting.find_by(key: name, keeper: keeper)
        return setting.value if setting
      end

      def respond_to_missing?(method_name, include_private = false)
        super || (method_name.match(/^(?!define_method).*$/) && where(key: method_name).present?)
      end
    end

    private

    def allowed_key
      errors.add(:key, :not_allowed) if key && Setting.methods.include?(key.to_sym)
    end
  end
end

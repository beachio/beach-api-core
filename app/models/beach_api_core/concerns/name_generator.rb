module BeachApiCore::Concerns::NameGenerator
  extend ActiveSupport::Concern

  included do
    before_validation :generate_name

    private

    def generate_name
      return if title.blank? || name.present?
      self.name = title.parameterize(separator: '_')
    end
  end
end

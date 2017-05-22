module BeachApiCore
  # Template model should contain template name and value with tokens.
  # Tokens are snake-cased strings in curly brackets (eg {first_name})
  #
  # BeachApiCore::Template.new(name: 'welcome', value: 'Hello, {first_name}!')
  class Template < ApplicationRecord
    enum kind: { email: 0 }

    validates :name, :value, presence: true
    validates :name, uniqueness: { scope: :kind }

    after_initialize :set_defaults
    before_validation :normalize_name

    private

    def normalize_name
      self.name = name.parameterize(separator: '_') if name
    end

    def set_defaults
      self.kind ||= :email
    end
  end
end

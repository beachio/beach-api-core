class IntegerValidator < Apipie::Validator::BaseValidator
  def initialize(param_description, argument)
    super(param_description)
    @type = argument
  end

  def validate(value)
    return !param_description.required if value.nil?
    !!(value.to_s =~ /^[-+]?[0-9]+$/)
  end

  def self.build(param_description, argument, options, block)
    return unless argument == Integer
    self.new(param_description, argument)
  end

  def description
    "Must be #{@type}."
  end
end

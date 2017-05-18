module BeachApiCore
  # BeachApiCore::TemplateParser.new(some_template, user: user).call -> string
  #
  # In order to parse `tokens` (eg {first_name}) add new private methods
  # that should be called TemplateKind_TokenName (eg email_first_name for email template)
  # that use @opts hash and provide expected value. Example:
  #
  # def email_first_name
  #   @opts[:user].first_name || 'there'
  # end
  class TemplateParser
    def initialize(template, opts = {})
      @template = template
      @opts = opts
    end

    def call
      @template.value.gsub(/{([\w_]+)}/) { |m| send("#{@template.kind}_#{$1}") }
    end
  end
end

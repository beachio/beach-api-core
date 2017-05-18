module BeachApiCore
  # BeachApiCore::TemplateParser.new(:example, user: user).call -> string
  #
  # In order to parse `tokens` (eg {first_name}) add new private methods
  # that use @opts hash and provide expected value. Example:
  #
  # def first_name
  #   @opts[:user].first_name
  # end
  class TemplateParser
    def initialize(template_name, opts = {})
      @template = Template.find_by!(name: template_name)
      @opts = opts
    end

    def call
      @template.value.gsub(/{([\w_]+)}/) { |m| parse_token($1) }
    end

    private

    def parse_token(token_name)
      raise NoMethodError if %w(initialize call parse_token).include?(token_name)
      send(token_name)
    end
  end
end

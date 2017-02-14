module Faker
  class Internet < Base
    class << self
      def redirect_uri
        "https://#{domain_name}.#{user_name}"
      end
    end
  end
end

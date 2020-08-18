module BeachApiCore
  module Factories
    ENGINE_ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))
    PATH = File.join(ENGINE_ROOT, 'spec', 'factories')
  end
end

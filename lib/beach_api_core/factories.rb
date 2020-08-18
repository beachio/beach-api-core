ENGINE_ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))

Dir[File.join(ENGINE_ROOT, 'spec', 'factories', '*.rb')].each { |file| require(file) }

class EngineStore
  @store = OpenStruct.new

  class << self
    def method_missing(m, *args, &block)
      @store[m.to_sym] ||= EngineStoreStruct.new
    end
  end

  class EngineStoreStruct < OpenStruct
    def method_missing(m, *args, &block)
      self[m.to_sym] ||= (args[0] || [])
    end
  end
end

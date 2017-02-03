module BeachApiCore
  class AppSerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end
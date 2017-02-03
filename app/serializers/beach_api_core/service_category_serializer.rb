module BeachApiCore
  class ServiceCategorySerializer < ActiveModel::Serializer
    attributes :id, :name
    has_many :services
  end
end
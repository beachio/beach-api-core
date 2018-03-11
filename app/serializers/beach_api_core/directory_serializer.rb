module BeachApiCore
  class DirectorySerializer < ActiveModel::Serializer
    attributes :id, :name

    has_many :directories
    has_many :flows
    

    # def directories
    #   DirectorySerializer
    # end
  end
end

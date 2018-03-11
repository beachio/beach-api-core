module BeachApiCore
  class Directory < ApplicationRecord
    has_ancestry

    alias_method :directories, :children
    
    has_many :flows

    validates_uniqueness_of :name, :scope => :ancestry

    validates_presence_of :name
  end
end

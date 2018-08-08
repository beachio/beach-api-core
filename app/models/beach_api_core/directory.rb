module BeachApiCore
  class Directory < ApplicationRecord
    has_ancestry

    alias_method :directories, :children
    
    belongs_to :bot
    has_many :flows

    # validates_uniqueness_of :name, :scope => :ancestry
    validates_presence_of :name

    def self.dirs
      dirs = (self.where("ancestry is null").order(:ancestry) + self.where("ancestry is not null").order(:ancestry)).index_by &:id
      dirs.map do |k, t|
        ids = (t.ancestry || "").split("/").map &:to_i
        [
          ids.map{|id| dirs[id].name + "/"}.join + t.name,
          t.id
        ]
      end
    end
  end
end

module BeachApiCore
  class Flow < ApplicationRecord
    include BeachApiCore::Concerns::Screenable
    validates :name, presence: true

    belongs_to :directory

    def self.main
      find_by(main: true)
    end

    def self.full_path
      BeachApiCore::Flow.all.map(&:full_path).sort_by { |k| k[:path] }
    end

    def full_path
      path = if directory
        ids = directory.ancestry.split("/").map &:to_i
        dirs = BeachApiCore::Directory.where(id: ids).index_by &:id
        dir_path = ids.map do |id|
          dirs[id].name
        end.join("/")
        dir_path + "/#{directory.name}/#{name}.flow"
      else
        "#{name}.flow"
      end

      {path: path, id: id}
    end
  end
end

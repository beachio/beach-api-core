module BeachApiCore::Concerns::AssetConcern
  extend ActiveSupport::Concern

  def file_blank?(attrs)
    file = attrs['file']
    file = Refile.parse_json(file, symbolize_names: true) if file.is_a?(String)
    file.blank?
  end
end

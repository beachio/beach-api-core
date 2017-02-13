module BeachApiCore::Concerns::AssetConcern
  extend ActiveSupport::Concern

  def file_blank?(attrs)
    return false if attrs['base64']
    file = attrs['file']
    file = Refile.parse_json(file, symbolize_names: true) if file.is_a?(String)
    file.blank?
  end
end

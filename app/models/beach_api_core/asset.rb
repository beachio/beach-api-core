module BeachApiCore
  class Asset < ApplicationRecord
    belongs_to :entity, polymorphic: true

    attachment :file
    validates :file, :entity, presence: true

    def base64=(value)
      partitions = value.partition(';base64,')
      decoded_image = Base64.decode64(partitions.last)
      content_type = partitions.first.gsub(/data\:/, '')

      Tempfile.new('asset').tap do |f|
        f.binmode
        f.write(decoded_image)
        f.unlink
        assign_attributes(file: f,
                          file_filename: "asset.#{content_type.gsub(/image\//, '')}",
                          file_size: decoded_image.size,
                          file_content_type: content_type
        )
      end
    end
  end
end

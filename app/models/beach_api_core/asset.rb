module BeachApiCore
  class Asset < ApplicationRecord
    belongs_to :entity, polymorphic: true

    attachment :file
    validates :file, :entity, :file_extension, presence: true

    before_validation :set_file_extension

    scope :images, -> { where(file_extension: IMAGE_EXTENSION) }
    scope :files, -> { where.not(file_extension: IMAGE_EXTENSION) }

    IMAGE_EXTENSION = %i(jpg jpeg bmp png gif).freeze

    def name=(value)
      self.file_filename = value
    end

    def base64=(value)
      partitions = value.partition(';base64,')
      decoded_image = Base64.decode64(partitions.last)
      content_type = partitions.first.gsub(/data\:/, '')

      Tempfile.new('asset').tap do |f|
        f.binmode
        f.write(decoded_image)
        f.rewind
        assign_attributes(file: f,
                          file_filename: file_filename || "asset.#{content_type.gsub(%r{image/}, '')}",
                          file_size: decoded_image.size,
                          file_content_type: content_type)
      end
    end

    private

    def set_file_extension
      self.file_extension = file_filename.split('.').last.to_s.downcase if file_filename
    end
  end
end

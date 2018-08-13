require 'happymapper'

module Hydra::Works::Characterization
  class FitsDocument
    include HappyMapper
    class Identification
      include HappyMapper

      class Identity
        include HappyMapper

        class ExifTool
          include HappyMapper
          attribute :exif_tool_version, String, tag: 'toolversion'
        end

        has_many :tool, ExifTool, tag: 'tool[@toolname="Exiftool"]'
        attribute :format_label, String, tag: 'format'
        attribute :mime_type, String, tag: 'mimetype'
      end
      has_one :identity, Identity
    end

    class FileInfo
      include HappyMapper
      element :file_size, String, tag: 'size'
      element :date_modified, String, tag: 'lastmodified'
      element :filename, String, tag: 'filename'
      element :original_checksum, String, tag: 'md5checksum'
      element :date_created, String, tag: 'created'
      element :rights_basis, String, tag: 'rightsBasis'
      element :copyright_basis, String, tag: 'copyrightBasis'
      element :copyright_note, String, tag: 'copyrightNote'
    end

    class FileStatus
      include HappyMapper
      element :well_formed, String, tag: 'well-formed'
      element :valid, String, tag: 'valid'
      element :status_message, String, tag: 'message'
    end

    class Metadata
      include HappyMapper

      class Document
        include HappyMapper
        element :file_title, String, tag: 'title'
        element :file_author, String, tag: 'author'
        element :file_language, String, tag: 'language'
        element :page_count, String, tag: 'pageCount'
        element :word_count, String, tag: 'wordCount'
        element :character_count, String, tag: 'characterCount'
        element :paragraph_count, String, tag: 'paragraphCount'
        element :line_count, String, tag: 'lineCount'
        element :table_count, String, tag: 'tableCount'
        element :graphics_count, String, tag: 'graphicsCount'
      end

      class Image
        include HappyMapper
        element :byte_order, String, tag: 'byteOrder'
        has_many :compression, String, tag: 'compressionScheme'
        has_many :width, String, tag: 'imageWidth'
        has_many :height, String, tag: 'imageHeight'
        element :color_space, String, tag: 'colorSpace'
        element :profile_name, String, tag: 'iccProfileName'
        element :profile_version, String, tag: 'iccProfileVersion'
        element :orientation, String, tag: 'orientation'
        element :color_map, String, tag: 'colorMap'
        element :image_producer, String, tag: 'imageProducer'
        element :capture_device, String, tag: 'captureDevice'
        element :scanning_software, String, tag: 'scanningSoftwareName'
        element :exif_version, String, tag: 'exifVersion'
        element :gps_timestamp, String, tag: 'gpsTimeStamp'
        element :latitude, String, tag: 'gpsDestLatitude'
        element :longitude, String, tag: 'gpsDestLongitude'
      end

      class Text
        include HappyMapper
        element :character_set, String, tag: 'charset'
        element :markup_basis, String, tag: 'markupBasis'
        element :markup_language, String, tag: 'markupLanguage'
      end

      class Audio
        include HappyMapper
        element :duration, String, tag: 'duration'
        element :bit_depth, String, tag: 'bitDepth'
        has_many :bit_rate, String, tag: 'bitRate'
        element :sample_rate, String, tag: 'sampleRate'
        element :channels, String, tag: 'channels'
        element :data_format, String, tag: 'dataFormatType'
        element :offset, String, tag: 'offset'
      end

      class Video
        include HappyMapper

        class Track
          include HappyMapper

          element :width, String, tag: 'width'
          element :height, String, tag: 'height'
          element :aspect_ratio, String, tag: 'aspectRatio'
          element :frame_rate, String, tag: 'frameRate'
        end

        element :width, String, tag: 'imageWidth' # for fits_0.8.5
        element :height, String, tag: 'imageHeight' # for fits_0.8.5
        element :sample_rate, String, tag: 'sampleRate' # for fits_0.8.5
        element :audio_sample_rate, String, tag: 'audioSampleRate' # for fits_0.8.5
        element :frame_rate, String, tag: 'frameRate' # for fits_0.8.5

        element :duration, String, tag: 'duration'

        element :bit_rate, String, tag: 'bitRate' # for fits_1.2.0
        has_one :track, Track, tag: 'track[@type="video"]' # for fits_1.2.0
      end

      has_one :document, Document
      has_one :image, Image
      has_one :text, Text
      has_one :audio, Audio
      has_one :video, Video
    end

    tag 'fits'

    attribute :fits_version, String, tag: 'version'

    has_one :identification, Identification
    has_one :fileinfo, FileInfo
    has_one :filestatus, FileStatus
    has_one :metadata, Metadata

    delegate :identity, to: :identification
    delegate :format_label, :tool, to: :identity

    # Can't use .mime_type because it's already defined for this document so method missing won't work.
    def file_mime_type
      val = identity.mime_type
      return val.split(',').first if val.present? && val.include?(',')
      val
    end

    delegate :exif_tool_version, to: :tool
    delegate :file_size, :filename, :original_checksum, :date_modified,
             :date_created, :rights_basis, :copyright_basis, :copyright_note,
             to: :fileinfo

    delegate :well_formed, :valid, :filestatus_message, to: :filestatus

    delegate :document, :image, :video, :text, :audio, to: :metadata
    delegate :track, :frame_rate, to: :video

    delegate :file_title, :file_author, :page_count, :file_language, :word_count,
             :character_count, :paragraph_count, :line_count, :table_count,
             :graphics_count, to: :document

    delegate :byte_order, :compression, :width, :height, :color_space,
             :profile_name, :profile_version, :orientation, :color_map,
             :image_producer, :capture_device, :scanning_software, :exif_version,
             :gps_timestamp, :latitude, :longitude, to: :image

    delegate :width, :height, :duration, :sample_rate, :audio_sample_rate,
             :bit_rate, to: :video, prefix: :video
    delegate :width, :height, to: :track, prefix: :video_track
    delegate :frame_rate, to: :track, prefix: :track
    delegate :aspect_ratio, to: :track

    delegate :character_set, :markup_basis, :markup_language, to: :text

    delegate :duration, :sample_rate, :bit_rate, to: :audio, prefix: :audio
    delegate :bit_depth, :channels, :data_format, :offset, to: :audio
  end
end

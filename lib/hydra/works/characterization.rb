module Hydra::Works
  module Characterization
    extend ActiveSupport::Autoload

    class << self
      attr_accessor :mapper
      def mapper
        @mapper ||= mapper_defaults
      end

      def mapper_defaults
        { audio_duration: :duration, audio_sample_rate: :sample_rate, exif_tool_version: :exif_version,
          file_author: :creator, file_language: :language, file_mime_type: :mime_type,
          video_audio_sample_rate: :sample_rate, video_duration: :duration, video_height: :height,
          video_sample_rate: :sample_rate, video_width: :width }
      end
    end

    autoload :FitsDocument, 'hydra/works/characterization/fits_document.rb'

    autoload_under 'schema' do
      autoload :AudioSchema
      autoload :BaseSchema
      autoload :DocumentSchema
      autoload :ImageSchema
      autoload :VideoSchema
    end
  end
end

module Hydra::Works
  module Characterization
    extend ActiveSupport::Autoload

    class << self
      attr_accessor :mapper
      def mapper
        @mapper ||= mapper_defaults
      end

      def mapper_defaults
        { audio_duration: :duration, audio_sample_rate: :sample_rate,
          file_author: :creator, file_language: :language, file_mime_type: :mime_type,
          video_audio_sample_rate: :sample_rate, video_duration: :duration, video_height: :height, video_track_height: :height,
          video_sample_rate: :sample_rate, video_width: :width, video_track_width: :width, track_frame_rate: :frame_rate,
          audio_bit_rate: :bit_rate, video_bit_rate: :bit_rate }
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

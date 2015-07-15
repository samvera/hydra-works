module Hydra::Works::GenericFile
  module Derivatives
    extend ActiveSupport::Concern
    
    included do
      include Hydra::Derivatives

      # Sets output_file_service to PersistDerivative instead of default Hydra::Derivatives::PersistBasicContainedOutputFileService
      Hydra::Derivatives.output_file_service = Hydra::Works::PersistDerivative

      # This was taken directly from Sufia's GenericFile::Derivatives and modified to exclude any processing that modified the original file
      makes_derivatives do |obj|
        case obj.original_file.mime_type
        when *pdf_mime_types
          obj.transform_file :original_file, thumbnail: { format: 'jpg', size: '338x493' }
        when *office_document_mime_types
          obj.transform_file :original_file, { thumbnail: { format: 'jpg', size: '200x150>' } }, processor: :document
        when *video_mime_types
          obj.transform_file :original_file, { thumbnail: { format: 'jpg' } }, processor: :video
        when *image_mime_types
          obj.transform_file :original_file, thumbnail: { format: 'jpg', size: '200x150>' }
        end
      end

    end

  end
end
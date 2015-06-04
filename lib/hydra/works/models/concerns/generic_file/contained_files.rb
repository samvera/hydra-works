module Hydra::Works::GenericFile::ContainedFiles
  extend ActiveSupport::Concern

  # HydraWorks supports only one each of original_file, thumbnail, and extracted_text. However
  # you are free to add an unlimited number of addtition types such as different resolutions
  # of images, different derivatives, etc, and use any established vocabulary you choose.

  # TODO: se PCDM vocab class when projecthydra-labs/hydra-pcdm#80 is merged
  
  def original_file
    file_of_type(::RDF::URI("http://pcdm.org/OriginalFile"))
  end

  def thumbnail
    file_of_type(::RDF::URI("http://pcdm.org/ThumbnailImage"))
  end

  def extracted_text
    file_of_type(::RDF::URI("http://pcdm.org/ExtractedText"))
  end

end

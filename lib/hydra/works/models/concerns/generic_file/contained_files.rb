module Hydra::Works::GenericFile::ContainedFiles
  extend ActiveSupport::Concern

  # HydraWorks supports only one each of original_file, thumbnail, and extracted_text. However
  # you are free to add an unlimited number of addtition types such as different resolutions
  # of images, different derivatives, etc, and use any established vocabulary you choose.

  # TODO: se PCDM vocab class when projecthydra-labs/hydra-pcdm#80 is merged
  
  def original_file
    attached_file_type(::RDF::URI("http://pcdm.org/OriginalFile")).first
  end

  def thumbnail
    attached_file_type(::RDF::URI("http://pcdm.org/ThumbnailImage")).first
  end

  def extracted_text
    attached_file_type(::RDF::URI("http://pcdm.org/ExtractedText")).first
  end

  private

  def attached_file_type uri
    self.files.reject do |file|
      file.metadata_node.query(predicate: RDF.type, object: uri).map(&:object).empty?
    end
  end

end

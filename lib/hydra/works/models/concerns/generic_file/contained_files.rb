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

  # Wraps the #files method provided by PCDM::ObjectBehavior to accept a :type argument
  # If you provide a :type agrument, filters contained files, returning only files that match the requested type.  See #filter_files_by_type
  def files(args={})
    if args[:type]
      filter_files_by_type(args[:type])
    else
      super()
    end
  end

  # Returns directly contained files that have the requested RDF Type
  # @param [RDF::URI] uri for the desired Type
  # @example
  #   filter_files_by_type(::RDF::URI("http://pcdm.org/ExtractedText"))
  def filter_files_by_type uri
    self.files.reject do |file|
      file.metadata_node.query(predicate: RDF.type, object: uri).map(&:object).empty?
    end
  end

  # Finds or Initializes directly contained file with the requested RDF Type
  # @param [RDF::URI] uri for the desired Type
  # @example
  #   file_of_type(::RDF::URI("http://pcdm.org/ExtractedText"))
  def file_of_type uri
    matching_files =  files(type: uri)
    if  matching_files.empty?
      file = self.files.build
      Hydra::Works::AddTypeToFile.call(file, uri)
    else
      return matching_files.first
    end
  end

end

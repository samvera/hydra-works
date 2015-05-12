module Hydra::Works::ContainedFiles
  extend ActiveSupport::Concern

  # We can use PCDM vocab class when projecthydra-labs/hydra-pcdm#80 is merged

  included do
    directly_contains :files, has_member_relation: ::RDF::URI("http://pcdm.org/hasFile"), class_name: "Hydra::Works::File"
  end

  def original_file
    self.files.reject do |file|
      file.metadata_node.query(predicate: RDF.type, object: ::RDF::URI("http://pcdm.org/OriginalFile")).map(&:object).empty?
    end
  end

  def thumbnail
    self.files.reject do |file|
      file.metadata_node.query(predicate: RDF.type, object: ::RDF::URI("http://pcdm.org/ThumbnailImage")).map(&:object).empty?
    end
  end

  def extracted_text
    self.files.reject do |file|
      file.metadata_node.query(predicate: RDF.type, object: ::RDF::URI("http://pcdm.org/ExtractedText")).map(&:object).empty?
    end
  end  

end

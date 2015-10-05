class BaseSchema < ActiveTriples::Schema
  property :filename, predicate: RDF::Vocab::EBUCore.filename, multiple: false
  property :format_label, predicate: RDF::Vocab::PREMIS.hasFormatName
  property :file_size, predicate: RDF::Vocab::EBUCore.fileSize
  property :well_formed, predicate: RDF::URI.new("http://projecthydra.org/ns/fits/wellFormed")
  property :valid, predicate: RDF::URI.new("http://projecthydra.org/ns/fits/valid")
  property :date_created, predicate: RDF::Vocab::EBUCore.dateCreated
  property :last_modified, predicate: RDF::Vocab::EBUCore.dateModified
  property :fits_version, predicate: RDF::Vocab::PREMIS.hasCreatingApplicationVersion
  property :exif_version, predicate: RDF::Vocab::EXIF.exifVersion
  property :original_checksum, predicate: RDF::Vocab::PREMIS.hasMessageDigest
  property :mime_type, predicate: RDF::Vocab::EBUCore.hasMimeType, multiple: false do |index|
    index.as :stored_searchable
  end
end

module Hydra::Works
  class AddFileToGenericFile

    # Adds a file to the generic_file
    # @param [Hydra::PCDM::GenericFile::Base] generic_file the file will be added to
    # @param [String] path to the file
    # @param [RDF::URI or String] type URI for the RDF.type that identifies the file's role within the generic_file
    # @param [Boolean] update_existing whether to update an existing file if there is one. When set to true, performs a create_or_update. When set to false, always creates a new file within generic_file.files.
    # @param [Boolean] versioning whether to create new version entries (only applicable if +type+ corresponds to a versionable file)

    def self.call(generic_file, path, type, update_existing: true, versioning: true, mime_type:nil, original_name:nil)
      raise ArgumentError, "supplied object must be a generic file" unless Hydra::Works.generic_file?(generic_file)
      raise ArgumentError, "supplied path must be a string" unless path.is_a?(String)
      raise ArgumentError, "supplied path to file does not exist" unless ::File.exists?(path)

      generic_file.save unless generic_file.persisted?

      if type.instance_of? Symbol
        raise ArgumentError, "you're attempting to add a file to a generic_file using '#{type}' association but the generic_file does not have an association called '#{type}''" unless object_has_association?(generic_file, type)
        if update_existing
          # if update_existing == true, try to retrieve existing element before building one
          current_file = generic_file.send(type)
        end
        unless current_file
          current_file = generic_file.send("build_#{type}")
        end
      else
        if update_existing
          # if update_existing == true, try to retrieve existing element before building one
          current_file = generic_file.filter_files_by_type(self.type_to_uri(type)).first
        end
        unless current_file
          generic_file.files.build
          current_file = generic_file.files.last
          Hydra::PCDM::AddTypeToFile.call(current_file, self.type_to_uri(type))
        end
      end

      current_file.content = ::File.open(path)
      current_file.original_name = original_name ? original_name : ::File.basename(path)
      current_file.mime_type = mime_type ? mime_type : Hydra::PCDM::GetMimeTypeForFile.call(path)

      if versioning
        if current_file.new_record?
          generic_file.save  # this persists current_file and its membership in generic_file.files container
        else
          current_file.save # if we updated an existing file's content we need to save the file explicitly
        end
        generic_file.reload     # this forces the generic_file to see the updated file
        if versioning
          current_file.create_version # Create version _after_ saving because ActiveFedora::Versionable#create_version tells Fedora to create a version that is a snapshot of the generic_file's current state within Fedora
        end
      else
        generic_file.save
      end

      generic_file
    end

    private

    # Returns true if an association exists corresponding to +symbol+
    def self.object_has_association?(object, symbol)
      !object.class.reflect_on_association(symbol).nil?
    end

    # Returns appropriate URI for the requested type
    #  * Converts supported symbols to corresponding URIs
    #  * Converts URI strings to RDF::URI
    #  * Returns RDF::URI objects as-is
    def self.type_to_uri(type)
      if type.instance_of?(::RDF::URI)
        return type
      elsif type.instance_of?(String)
        return ::RDF::URI(type)
      else
        raise ArgumentError, "Invalid file type.  You must submit a URI or a symbol."
      end
    end

  end
end

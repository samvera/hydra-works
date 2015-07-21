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

      # TODO required as a workaround for https://github.com/projecthydra/active_fedora/pull/858
      generic_file.save unless generic_file.persisted?

      updater_class = versioning ? VersioningUpdater : Updater
      updater = updater_class.new(generic_file, type, update_existing)
      status = updater.update(path, original_name, mime_type)
      status ? generic_file : false
    end

    class Updater
      attr_reader :generic_file, :current_file

      def initialize(generic_file, type, update_existing)
        @generic_file = generic_file
        @current_file = find_or_create_file(type, update_existing)
      end

      # @param [String] path path to the file
      # @param [String] original_name the original name of the file
      # @param [String] mime_type the content type of the file
      def update(path, original_name, mime_type)
        attach_attributes(path, original_name, mime_type)
        persist
      end

      private

        def persist
          if current_file.new_record?
            # persist current_file and its membership in generic_file.files container
            generic_file.save
          else
            # we updated the content of an existing file, so we need to save the file explicitly
            current_file.save
          end
        end

        def attach_attributes(path, original_name, mime_type)
          current_file.content = ::File.open(path)
          current_file.original_name = original_name ? original_name : ::File.basename(path)
          current_file.mime_type = mime_type ? mime_type : Hydra::PCDM::GetMimeTypeForFile.call(path)
        end

        # @param [Hydra::PCDM::GenericFile::Base] generic_file the parent object
        # @param [Symbol, RDF::URI] the type of association or filter to use
        # @param [true, false] update_existing when true, try to retrieve existing element before building one
        def find_or_create_file(type, update_existing)
          if type.instance_of? Symbol
            association = generic_file.association(type)
            raise ArgumentError, "you're attempting to add a file to a generic_file using '#{type}' association but the generic_file does not have an association called '#{type}''" unless association

            current_file = association.reader if update_existing
            current_file ||= association.build
          else
            current_file = generic_file.filter_files_by_type(type_to_uri(type)).first if update_existing
            unless current_file
              generic_file.files.build
              current_file = generic_file.files.last
              Hydra::PCDM::AddTypeToFile.call(current_file, type_to_uri(type))
            end
          end
        end

        # Returns appropriate URI for the requested type
        #  * Converts supported symbols to corresponding URIs
        #  * Converts URI strings to RDF::URI
        #  * Returns RDF::URI objects as-is
        def type_to_uri(type)
          case type
          when ::RDF::URI
            type
          when String
            ::RDF::URI(type)
          else
            raise ArgumentError, "Invalid file type.  You must submit a URI or a symbol."
          end
        end
      end

      class VersioningUpdater < Updater
        def update(*)
          super && current_file.create_version
        end
      end
  end
end

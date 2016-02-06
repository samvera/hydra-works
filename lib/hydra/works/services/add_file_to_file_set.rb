module Hydra::Works
  class AddFileToFileSet
    # Adds a file to the file_set
    # @param [Hydra::PCDM::FileSet] file_set the file will be added to
    # @param [IO,File,Rack::Multipart::UploadedFile, #read] object that will be the contents. If file responds to :mime_type, :content_type, :original_name, or :original_filename, those will be called to provide metadata.
    # @param [RDF::URI or String] type URI for the RDF.type that identifies the file's role within the file_set
    # @param [Boolean] update_existing whether to update an existing file if there is one. When set to true, performs a create_or_update. When set to false, always creates a new file within file_set.files.
    # @param [Boolean] versioning whether to create new version entries (only applicable if +type+ corresponds to a versionable file)

    def self.call(file_set, file, type, update_existing: true, versioning: true)
      fail ArgumentError, 'supplied object must be a file set' unless file_set.file_set?
      fail ArgumentError, 'supplied file must respond to read' unless file.respond_to? :read

      # TODO: required as a workaround for https://github.com/projecthydra/active_fedora/pull/858
      file_set.save unless file_set.persisted?

      updater_class = versioning ? VersioningUpdater : Updater
      updater = updater_class.new(file_set, type, update_existing)
      status = updater.update(file)
      status ? file_set : false
    end

    class Updater
      attr_reader :file_set, :current_file

      def initialize(file_set, type, update_existing)
        @file_set = file_set
        @current_file = find_or_create_file(type, update_existing)
      end

      # @param [#read] file object that will be interrogated using the methods: :path, :original_name, :original_filename, :mime_type, :content_type
      # None of the attribute description methods are required.
      def update(file)
        attach_attributes(file)
        persist
      end

      private

        def persist
          if current_file.new_record?
            # persist current_file and its membership in file_set.files container
            file_set.save
          else
            # we updated the content of an existing file, so we need to save the file explicitly
            current_file.save
          end
        end

        def attach_attributes(file)
          current_file.content = file
          current_file.original_name = determine_original_name(file)
          current_file.mime_type = determine_mime_type(file)
        end

        # Return mime_type based on methods available to file
        # @param object for mimetype to be determined. Attempts to use methods: :mime_type, :content_type, and :path.
        def determine_mime_type(file)
          return file.mime_type if file.respond_to? :mime_type
          return file.content_type if file.respond_to? :content_type
          return Hydra::PCDM::GetMimeTypeForFile.call(file.path) if file.respond_to? :path
          'application/octet-stream'
        end

        # Return original_name based on methods available to file
        # @param object for original name to be determined. Attempts to use methods: :original_name, :original_filename, and :path.
        def determine_original_name(file)
          if file.respond_to? :original_name
            file.original_name
          elsif file.respond_to? :original_filename
            file.original_filename
          elsif file.respond_to? :path
            ::File.basename(file.path)
          else
            ''
          end
        end

        # @param [Symbol, RDF::URI] the type of association or filter to use
        # @param [true, false] update_existing when true, try to retrieve existing element before building one
        def find_or_create_file(type, update_existing)
          if type.instance_of? Symbol
            association = file_set.association(type)
            fail ArgumentError, "you're attempting to add a file to a file_set using '#{type}' association but the file_set does not have an association called '#{type}''" unless association

            current_file = association.reader if update_existing
            current_file || association.build
          else
            current_file = file_set.filter_files_by_type(type_to_uri(type)).first if update_existing
            unless current_file
              file_set.files.build
              current_file = file_set.files.last
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
            fail ArgumentError, 'Invalid file type.  You must submit a URI or a symbol.'
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

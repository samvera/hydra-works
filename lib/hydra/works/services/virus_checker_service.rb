module Hydra::Works
  # Responsible for checking if the given file is a virus. Coordinates
  # with the underlying system virus scanner.
  class VirusCheckerService
    attr_accessor :original_file, :system_virus_scanner

    # @api public
    # @param original_file [String, #path]
    # @return true if a virus was detected
    # @return true if anti-virus was not able to run
    # @return false if the file was scanned and no viruses were found
    def self.file_has_virus?(original_file)
      new(original_file).file_has_virus?
    end

    def initialize(original_file, system_virus_scanner = default_system_virus_scanner)
      self.original_file = original_file
      self.system_virus_scanner = system_virus_scanner
    end

    # Default behavior is to raise a validation error and halt the save if a virus is found
    def file_has_virus?
      path = original_file.is_a?(String) ? original_file : local_path_for_file(original_file)
      scan_result = system_virus_scanner.call(path)
      handle_virus_scan_results(path, scan_result)
    end

    private

      # Stubbing out the behavior of "The Clam" was growing into a rather nasty
      # challenge. So instead I'm injecting a system scanner. This allows me to
      # now test the default system scanner in isolation from the general response
      # to a system scan.
      def default_system_virus_scanner
        if defined?(ClamAV)
          ClamAV.instance.method(:scanfile)
        else
          lambda do |_path|
            :no_anti_virus_was_run
          end
        end
      end

      def handle_virus_scan_results(path, scan_result)
        case scan_result
        when 0 then return false
        when 1
          warning("A virus was found in #{path}: #{scan_result}")
          true
        else
          warning "Virus checking disabled, #{path} not checked"
          true
        end
      end

      def warning(msg)
        ActiveFedora::Base.logger.warn msg if ActiveFedora::Base.logger
      end

      # Returns a path for reading the content of +file+
      # @param [File] file object to retrieve a path for
      def local_path_for_file(file)
        return file.path if file.respond_to?(:path)
        Tempfile.open('') do |t|
          t.binmode
          t.write(file.content.read)
          file.content.rewind
          t.close
          t.path
        end
      end
  end
end

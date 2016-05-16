module Hydra::Works
  # Responsible for checking if the given file is a virus. Coordinates
  # with the underlying system virus scanner.
  class VirusCheckerService
    attr_accessor :original_file, :system_virus_scanner

    # @api public
    # @param original_file [String, #path]
    # @return true or false result from system_virus_scanner
    def self.file_has_virus?(original_file)
      new(original_file).file_has_virus?
    end

    def initialize(original_file, system_virus_scanner = Hydra::Works.default_system_virus_scanner)
      self.original_file = original_file
      self.system_virus_scanner = system_virus_scanner
    end

    # Default behavior is to raise a validation error and halt the save if a virus is found
    def file_has_virus?
      path = original_file.is_a?(String) ? original_file : local_path_for_file(original_file)
      system_virus_scanner.infected?(path)
    end

    private

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

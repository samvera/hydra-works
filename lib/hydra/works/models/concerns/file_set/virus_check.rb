module Hydra::Works
  module VirusCheck
    extend ActiveSupport::Concern

    included do
      validate :detect_viruses
    end

    # Default behavior is to raise a validation error and halt the save if a virus is found
    def detect_viruses
      return unless original_file && original_file.new_record?
      path = original_file.is_a?(String) ? original_file : local_path_for_file(original_file)
      unless defined?(ClamAV)
        warning "Virus checking disabled, #{path} not checked"
        return
      end
      scan_result = ClamAV.instance.scanfile(path)
      handle_virus_scan_results(path, scan_result)
    end

    private

      def handle_virus_scan_results(path, scan_result)
        if scan_result == 0
          true
        else
          virus_message = "A virus was found in #{path}: #{scan_result}"
          warning(virus_message)
          errors.add(:base, virus_message)
          false
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

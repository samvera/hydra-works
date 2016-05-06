module Hydra::Works
  module VirusCheck
    extend ActiveSupport::Concern

    included do
      validate :detect_viruses
      def detect_viruses
        return true unless original_file && original_file.new_record? # We have a new file to check
        return true unless VirusCheckerService.file_has_virus?(original_file)
        errors.add(:base, "Failed to verify uploaded file is not a virus")
        false
      end
    end
  end
end

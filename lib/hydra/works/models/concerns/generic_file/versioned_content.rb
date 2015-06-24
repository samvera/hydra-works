module Hydra::Works::GenericFile
  # Allows a GenericFile to treat the version history of the original_file as the GenericFile's version history
  module VersionedContent

    def content_versions
      self.original_file.versions.all
    end

    def latest_content_version
      self.original_file
    end

    def current_content_version_uri
      self.original_file.versions.last.uri
    end

  end
end
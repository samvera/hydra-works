module Hydra::Works::GenericFile
  # Allows a GenericFile to treat the version history of the original_file as the GenericFile's version history
  module VersionedContent
    def content_versions
      original_file.versions.all
    end

    def latest_content_version
      original_file.versions.last
    end

    def current_content_version_uri
      original_file.versions.last.uri
    end
  end
end

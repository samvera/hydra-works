module Hydra::Works
  module CurationConcern
    module DestroyFilesToo
      extend ActiveSupport::Concern

      included do
        before_destroy :before_destroy_cleanup_generic_files
      end

      def before_destroy_cleanup_generic_files
        files.each(&:destroy)
      end
    end
  end
end

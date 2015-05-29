module Hydra::Works
  class AddOriginalFile

    # Convenience service for attaching original file.
    # Sets :type of options parameter to ::RDF::URI("http://pcdm.org/OriginalFile")
    # @param object [GenericFile] object to which original file is being attached.
    # @param file [#read] The contents of the original file. An object which responds to read.
    # @param options [Hash] 
    # @option options [String] :original_name Name of file.
    # @option options [String] :mime_type Default will be text/plain if not given.
    # @option options [Boolean] :replace Replace first file of same type attached to the object.
    # 
    # @see AddFileToGenericFile#call
    def self.call(object, file, options={})
      options[:type] = ::RDF::URI("http://pcdm.org/OriginalFile")
      Hydra::Works::AddFileToGenericFile.call(object, file, options)
    end

  end
end

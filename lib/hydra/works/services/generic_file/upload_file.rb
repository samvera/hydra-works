module Hydra::Works
  class UploadFileToGenericFile

    def self.call(object, path, additional_services=[], replace=false)
      raise ArgumentError, "supplied object must be a generic file" unless Hydra::Works.generic_file?(object)
      raise ArgumentError, "supplied path must be a string" unless path.is_a?(String)
      raise ArgumentError, "supplied path to file does not exist" unless ::File.exists?(path)
    
      if object.original_file.nil? || object.original_file.new_record?
        Hydra::Works::AddOriginalFile.call(object, path)
      else
        if replace
          Hydra::Works::AddOriginalFile.call(object, path, replace)
        else
          Hydra::Works::AddVersionedOriginalFile.call(object, path)
        end
      end

      object.save
      object.reload

      # Call any additional services
      additional_services.each do |service|
        service.call(object)
      end

      object.save
      object
    end

  end
end

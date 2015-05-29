module Hydra::Works
  class MoveGenericFileToGenericWork

    ##
    # Move a generic file from one generic work to another
    #
    # @param [Hydra::Works::GenericWork] :old_parent_work where the generic file currently lives
    # @param [Hydra::Works::GenericWork] :new_parent_work where the generic file is being moved
    # @param [Hydra::Works::GenericFile] :child_generic_file being moved
    #
    # @return [Hydra::Works::GenericWork] the destination generic work
    def self.call(old_parent_work, new_parent_work, child_generic_file)
      AddGenericFileToGenericWork.call(new_parent_work, child_generic_file)
      RemoveGenericFileFromGenericWork.call(old_parent_work, child_generic_file)
      new_parent_work
    end

  end
end
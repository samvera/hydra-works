module Hydra::Derivatives
  class Work < Hydra::Derivatives::Image

    def source_file
      object.send(source_name.to_s)
    end

  end
end

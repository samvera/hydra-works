module Hydra
  module Works
    class Railtie < Rails::Railtie
      initializer "hydra-works.initializer" do
        # Sets output_file_service to PersistDerivative instead of default Hydra::Derivatives::PersistBasicContainedOutputFileService
        Hydra::Derivatives.output_file_service = Hydra::Works::PersistDerivative
      end
    end
  end
end

require 'rspec'

unless defined?(Rails) # If we are in a Rails context this is overkill.
  Dir[File.expand_path('../../app/*', __FILE__)].each do |dir|
    $LOAD_PATH << dir
  end
  $LOAD_PATH << File.expand_path('../../lib', __FILE__)

  unless defined?(require_dependency)
    def require_dependency(*files)
      require *files
    end
  end
end
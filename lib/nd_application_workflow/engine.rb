module NdApplicationWorkflow
  class Engine < ::Rails::Engine
    isolate_namespace NdApplicationWorkflow
    config.generators do |g|
      g.test_framework :rspec
    end

  end
end

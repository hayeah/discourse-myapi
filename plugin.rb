# name: my_api
# about: My custom API extensions
# version: 0.1
# authors: API

module ::MyApi
  class Engine < ::Rails::Engine
    engine_name "my_api"
    isolate_namespace MyApi
  end
end

# # Rails.configuration.assets.precompile += ['docker-manager-app.js', 'docker-manager-app.css', 'docker-manager-config.js', 'docker-manager-vendor.js', 'images/docker-manager.png']

after_initialize do
  # class Discourse::Application
  #   plugin_path = File.expand_path("..",__FILE__)
  #   p ["plugin root",plugin_path]
  #   config.autoload_paths << plugin_path
  # end
  Discourse::Application.routes.append do
    mount ::MyApi::Engine, at: "/myapi"
  end
end

# # register_asset "javascripts/upgrade-header.js.handlebars"

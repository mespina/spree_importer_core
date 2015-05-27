module Spree
  module ImporterCore
    module Generators
      class ImporterGenerator < Rails::Generators::NamedBase
        source_root File.expand_path('../templates', __FILE__)

        def add_importer_class
          template('importer.rb', "app/models/spree/#{file_name}_importer.rb")
        end

        def add_locale
          inject_into_file 'config/locales/spree_importer_core.en.yml', "
        #{file_name}:
          title: #{file_name.titleize} Importer
          name: #{file_name.titleize}", :after => "importers:", :verbose => true
        end

        def add_to_importers
          append_file 'config/initializers/spree.rb', "Spree::ImporterCore::Config.importers << Spree::#{class_name}Importer\n"
        end
      end
    end
  end
end

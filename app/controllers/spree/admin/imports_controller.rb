module Spree
  module Admin
    class ImportsController < Spree::Admin::ResourceController
      before_filter :set_importer

      after_filter :perform_import, only: :create

      # GET /admin/importers/:importer/imports
      def index
        session[:return_to] = request.url
        respond_with(@collection)
      end

      # GET /admin/importers/:importer/imports/template
      def template
        file = File.open(@importer.sample_file)

        send_data file.read, :filename => File.basename(@importer.sample_file)
      end

      # GET /admin/importers/:importer_id/imports/new
      # default

      # POST /admin/importers/:importer_id/imports
      # default

      private
        def perform_import
          @import.perform if @import.persisted?
        end

        def set_importer
          @importer = Spree::ImporterCore::Config.importers.select{|importer| importer.key.to_s == params[:importer_id].to_s}.first
        end

      protected
        def collection
          model_class.accessible_by(current_ability, action).where(importer: params[:importer_id].to_s)
        end
    end
  end
end

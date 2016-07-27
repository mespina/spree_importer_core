require 'roo'
require 'roo-xls'

module Spree
  module ImporterCore
    class BaseImporter
      def initialize import_id, options={}
        @import  = Spree::Import.find(import_id)

        @filename = @import.document_file_name

        if File.exists?(@import.document.path)
          @filepath = @import.document.path
        else
          @filepath = @import.document.url
        end

        @spreadsheet = nil

        @import.messages = []

        @rows = 0

        begin
          open_spreadsheet

          @rows = @spreadsheet.last_row
        rescue => e
          add_error message: e.message, backtrace: e.backtrace, row_index: nil, data: {}
        end

        # Custom behavior
      end

      # Descriptive name for importer
      def self.name
        Spree.t(:name, scope: [:spree_importer_core, :importers, key])
      end

      # A unique key identifier for importer
      def self.key
        self.to_s.gsub('Importer', '').demodulize.underscore
      end

      # Load a file and the get data from each file row
      def process
        before_process

        # Load each row element
        2.upto(@rows).each do |row_index|
          ActiveRecord::Base.transaction do
            begin
              load_data row: @spreadsheet.row(row_index)

            rescue => e
              add_error message: e.message, backtrace: e.backtrace, row_index: row_index, data: @spreadsheet.row(row_index)

              raise ActiveRecord::Rollback
            end
          end
        end

        after_process
      end

      # Load a file and the get data from each file row
      #
      # @params
      #   row   => A row to be processed
      def load_data(row:)
        raise "#{__FILE__}:#{__LINE__} You must define it"
      end

      # The importer sample file
      def self.sample_file
        Rails.root.join("lib/spree_importer_core/templates/#{key}.xlsx")
      end

      private
        # Returns a Roo instance acording the file extension.
        def open_spreadsheet
          @spreadsheet = Roo::Spreadsheet.open(@filepath, extension: :xlsx)
          @spreadsheet.default_sheet = @spreadsheet.sheets.first
        rescue Zip::Error
          # Supports spreadsheets with extension .xls
          @spreadsheet = Roo::Spreadsheet.open(@filepath)
          @spreadsheet.default_sheet = @spreadsheet.sheets.first
        rescue => e
          add_error message: e.message, backtrace: e.backtrace, row_index: nil, data: {}
        end

        # Add errors to import
        #
        # @params
        #   message   => Error message
        #   backtrace => Error Bactrace
        #   row_index => Failed row index
        #   data      => Readed data
        def add_error(message:, backtrace:, row_index:, data:)
          @import.messages << {message: message, backtrace: backtrace, row_index: row_index, data: data}
        end

        # Set the import in progress
        def before_process
          @import.process unless @import.processing?
        end

        # Set the import as finished, either for completed or failed
        def after_process
          if @import.messages.nil? or @import.messages.empty?
            @import.complete unless @import.completed?
          else
            @import.failure unless @import.failed?
          end
        end
    end
  end
end

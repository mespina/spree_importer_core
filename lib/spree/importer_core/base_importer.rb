require 'roo'

module Spree
  module ImporterCore
    class BaseImporter
      def initialize import_id, options={}
        @import  = Spree::Import.find(import_id)

        @filename = @import.document_file_name
        @filepath = @import.document.path

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
        raise "#{__FILE__}:#{__LINE__} You must define it"
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
              add_error message: e.message, backtrace: e.backtrace, row_index: row_index, data: data

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
        Rails.root.join("lib/templates/#{key}.csv")
      end

      private
        # Returns a Roo instance acording the file extension.
        def open_spreadsheet
          case File.extname(@filename)
            when '.csv'  then @spreadsheet = Roo::CSV.new(@filepath)
            when '.xls'  then @spreadsheet = Roo::Excel.new(@filepath, nil, :ignore)
            when '.xlsx' then @spreadsheet = Roo::Excelx.new(@filepath, nil, :ignore)

            else raise Spree.t(:unknown_file_type, scope: :spree_importer_core, filename: @filename)
          end

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

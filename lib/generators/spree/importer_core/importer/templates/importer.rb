class Spree::<%= class_name %>Importer < Spree::ImporterCore::BaseImporter
  # A unique key identifier for importer
  def self.key
    :<%= plural_name %>
  end

  # Load a file and the get data from each file row
  def load_data(row:)
    # ToDo
  end
end

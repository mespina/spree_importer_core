class ImportJob < ActiveJob::Base
  queue_as :default

  def perform(import)
    import.importer_class.new(import.id).process
  end
end

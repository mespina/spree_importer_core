class Spree::Import < ActiveRecord::Base
  include GlobalID::Identification

  serialize :messages, Array

  ALLOWED_FILE_FORMATS = /^text\/csv|application\/(octet-stream|vnd.openxmlformats-officedocument.spreadsheetml.sheet)$/

  has_attached_file :document

  validates_attachment_presence :document
  validates_attachment_content_type :document, content_type: ALLOWED_FILE_FORMATS
  # do_not_validate_attachment_file_type :document

  state_machine :initial => :created do
    event :process do
      transition :created => :processing
    end

    event :complete do
      transition :processing => :completed
    end

    event :failure do
      transition :processing => :failed
    end

    event :stop do
      transition :created => :stopped
    end

    event :retry do
      transition :failed  => :processing, if: lambda {|import| !import.failed? }
      transition :stopped => :processing, if: lambda {|import| !import.stopped?}
    end

    after_transition to: :processing do  |import, transition|
      import.update_attribute :started_at, DateTime.now
    end

    after_transition to: [:completed, :failed, :stopped] do  |import, transition|
      import.update_attribute :finished_at, DateTime.now
    end
  end

  def status_icon
    case state
    when 'created' then return ''
    when 'processing' then return 'glyphicon-refresh gly-spin'
    when 'completed' then return 'glyphicon-ok'
    when 'failed' then return 'glyphicon-alert'
    when 'stopped' then return 'glyphicon-stop'
    else return ''
    end
  end

  def importer_class
    Spree::ImporterCore::Config.importers.select{|i| i.key.to_s == self.importer.to_s}.first
  end
end

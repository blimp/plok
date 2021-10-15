class Log < ActiveRecord::Base
  belongs_to :loggable, polymorphic: true

  serialize :data, Hash

  # TODO: A file column is currently used in Raamwinkel to link either PDFs or
  # images to a log message. We'd prefer not use Uploader classes in Plok, so
  # I'll leave this comment as a reference until assets become available in
  # Plok.
  #mount_uploader :file, LogFileUploader

  default_scope { order('created_at DESC, id DESC') }
  scope :status, -> { where(category: 'status') }

  validate :some_content_present?

  def self.latest
    Log.first # default_scope sorts in descending order.
  end

  def some_content_present?
    errors.add(:content, :blank) if file.blank? && content.blank?
  end
end

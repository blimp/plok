class Log < ActiveRecord::Base
  belongs_to :loggable, polymorphic: true

  serialize :data, Hash

  # TODO:
  #mount_uploader :file, LogFileUploader

  default_scope { order('created_at DESC, id DESC') }
  scope :status, -> { where(category: 'status') }

  validate :some_content_present?

  def self.latest
    Log.first # default_scope sorts in descending order.
  end

  # TODO: This is an unnecessary abstraction for this engine. An alternative
  # approach is to put any path needed in your application into the data
  # column.
  #def loggable_path
  #return unless class_exists?(loggable.class.to_s.concat('Decorator'))
  #return unless loggable.decorate.respond_to?(:backend_path)
  #loggable.decorate.backend_path
  #end

  def some_content_present?
    errors.add(:content, :blank) if file.blank? && content.blank?
  end
end

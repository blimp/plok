class QueuedTask < ActiveRecord::Base
  include Plok::Loggable

  serialize :data, Hash

  validates :klass, presence: true

  scope :locked, -> { where(locked: true) }
  scope :unlocked, -> { where('locked = 0 OR locked IS NULL') }
  scope :in_past, -> { where(perform_at: nil).or(where('perform_at <= ?', Time.zone.now)) }
  scope :in_future, -> { where('perform_at > ?', Time.zone.now) }

  def lock!
    update_attribute :locked, true
  end

  def unlock!
    update_attribute :locked, false
  end

  def unlocked?
    !locked?
  end

  def execute!
    klass.to_s.constantize.new(data).execute!
  end

  def self.queue(klass, data)
    task = create!(klass: klass.to_s, data: data.except(:perform_at))
    task.update(perform_at: data[:perform_at]) if data[:perform_at].present?
    task
  end

  def self.queue_unless_already_queued(klass, data)
    task = find_by(klass: klass, data: data)
    return task if task.present?
    self.queue(klass, data)
  end

  def dequeue!
    destroy
  end

  def process!
    lock!

    begin
      execute!
      dequeue!
    rescue
      raise
    ensure
      unlock! unless destroyed?
    end
  end

  def stuck?
    return false if locked?
    # Make sure task is past its perform_at timestamp.
    return perform_at <= 30.minutes.ago if perform_at.present?
    created_at <= 30.minutes.ago
  end
end

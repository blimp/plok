class QueuedTask < ActiveRecord::Base
  serialize :data, Hash

  validates :klass, presence: true

  scope :locked, -> { where(locked: true) }
  scope :unlocked, -> { where('locked = 0 OR locked IS NULL') }
  scope :past, -> { where('perform_at IS NULL OR perform_at <= ?', Time.zone.now) }
  scope :future, -> { where('perform_at > ?', Time.zone.now) }

  LOW_PRIORITY = 0
  NORMAL_PRIORITY = 5
  HIGH_PRIORITY = 10

  def lock!
    Plok::Operations::QueuedTasks::Lock.new(self).execute!
  end

  def unlock!
    Plok::Operations::QueuedTasks::Unlock.new(self).execute!
  end

  def unlocked?
    !locked?
  end

  def self.queue!(klass, data: nil, perform_at: nil, weight: NORMAL_PRIORITY)
    Plok::Operations::QueuedTasks::Queue.new(klass, data, perform_at, weight)
  end

  def execute!
    Plok::Operations::QueuedTasks::Process
      .new(self)
      .execute!
  end

  def stuck?
    # Locked means it's still being executed
    return false if locked?

    # Make sure task is past its perform_at timestamp.
    return perform_at <= 30.minutes.ago if perform_at.present?

    # Created more than 30 minutes ago
    created_at <= 30.minutes.ago
  end
end

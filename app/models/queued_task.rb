class QueuedTask < ActiveRecord::Base
  serialize :data, Hash

  validates :klass, presence: true

  scope :locked, -> { where(locked: true) }
  scope :unlocked, -> { where('locked = 0 OR locked IS NULL') }
  scope :past, -> { where('perform_at IS NULL OR perform_at <= ?', Time.zone.now) }
  scope :future, -> { where('perform_at > ?', Time.zone.now) }

  DEFAULT_PRIORITY = 0
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

  # TODO: Might be good to use named parameters for data and weight here.
  # Might be able to use the data var to store weight like the perform_at key.
  #
  # TODO: Refactor to a separate class.
  def self.queue(klass, data, weight = DEFAULT_PRIORITY)
    task = create!(
      klass: klass.to_s,
      weight: weight,
      attempts: 0,
      data: data&.except(:perform_at)
    )

    task.update(perform_at: data[:perform_at]) if data&.dig(:perform_at).present?
    task
  end

  def self.queue_unless_already_queued(klass, data, weight = DEFAULT_PRIORITY)
    task = find_by(klass: klass, data: data, weight: weight)
    return task if task.present?
    self.queue(klass, data, weight)
  end

  def execute!
    Plok::Operations::QueuedTasks::Process
      .new(self)
      .execute!
  end

  def stuck?
    return false if locked?

    # Make sure task is past its perform_at timestamp.
    return perform_at <= 30.minutes.ago if perform_at.present?

    created_at <= 30.minutes.ago
  end
end

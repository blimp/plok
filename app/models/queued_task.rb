class QueuedTask < ActiveRecord::Base
  include Plok::Loggable

  serialize :data, Hash

  validates :klass, presence: true

  scope :locked, -> { where(locked: true) }
  scope :unlocked, -> { where('locked = 0 OR locked IS NULL') }
  scope :in_past, -> { where(perform_at: nil).or(where('perform_at <= ?', Time.zone.now)) }
  scope :in_future, -> { where('perform_at > ?', Time.zone.now) }

  DEFAULT_PRIORITY = 0
  HIGH_PRIORITY = 10

  def lock!
    Plok::Operations::QueuedTasks::Lock.new(self).execute!
  end

  def unlock!
    update_attribute(:locked, false)
  end

  def unlocked?
    !locked?
  end

  def execute!
    klass.to_s.constantize.new(data).execute!
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

  def dequeue!
    destroy
  end

  def increase_attempts!
    update_column(:attempts, attempts + 1)
  end

  def process!
    lock!

    begin
      execute!
      dequeue!
    rescue
      raise
    ensure
      if persisted?
        increase_attempts!
        unlock!
      end
    end
  end

  def stuck?
    return false if locked?
    # Make sure task is past its perform_at timestamp.
    return perform_at <= 30.minutes.ago if perform_at.present?
    created_at <= 30.minutes.ago
  end
end

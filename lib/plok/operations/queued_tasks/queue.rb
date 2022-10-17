class Plok::Operations::QueuedTasks::Queue
  takes :klass, :data, :perform_at, :weight

  def execute!
    task = QueuedTask.find_by(klass: @klass, data: @data, weight: @weight)
    task.present? ? task : create_task
  end

  private

  def create_task
    QueuedTask.create!(
      klass: @klass.to_s,
      weight: @weight,
      attempts: 0,
      data: @data,
      perform_at: @perform_at
    )
  end
end

# TODO: Might be good to use named parameters for data and weight here.
# Might be able to use the data var to store weight like the perform_at key.
#
# TODO: Refactor to a separate class.
# def self.queue(klass, data, weight = DEFAULT_PRIORITY)
#   task = create!(
#     klass: klass.to_s,
#     weight: weight,
#     attempts: 0,
#     data: data&.except(:perform_at)
#   )
#
#   task.update(perform_at: data[:perform_at]) if data&.dig(:perform_at).present?
#   task
# end

# def self.queue_unless_already_queued(klass, data, weight = DEFAULT_PRIORITY)
#   task = find_by(klass: klass, data: data, weight: weight)
#   return task if task.present?
#   self.queue(klass, data, weight)
# end

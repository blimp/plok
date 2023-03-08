class Plok::Operations::QueuedTasks::Lock
  takes :queued_task

  def execute!
    @queued_task.update_attribute(:locked, true)
  end
end

class Plok::Operations::QueuedTasks::Unlock
  takes :queued_task

  def execute!
    @queued_task.update_attribute(:locked, false)
  end
end

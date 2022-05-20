class Plok::Operations::QueuedTasks::Process
  takes :queued_task

  def execute!
    lock

    begin
      run
      dequeue

    rescue
      raise

    ensure
      if persisted?
        increase_attempts
        unlock
      end
    end
  end

  private

  def lock
    @queued_task.lock!
  end

  def unlock
    @queued_task.unlock!
  end

  def run
    @queued_task.klass.to_s.constantize.new(@queued_task.data).execute!
  end

  def increase_attempts
    @queued_task.update_column(:attempts, @queued_task.attempts + 1)
  end

  def dequeue
    @queued_task.destroy
  end

  def persisted?
    @queued_task.persisted?
  end
end

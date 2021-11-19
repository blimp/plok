class AddIndexToQueuedTasksLocked < ActiveRecord::Migration[6.1]
  def change
    return if index_exists?(:queued_tasks, :locked)

    add_index :queued_tasks, :locked
  end
end

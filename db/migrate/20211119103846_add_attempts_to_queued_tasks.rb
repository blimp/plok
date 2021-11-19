class AddAttemptsToQueuedTasks < ActiveRecord::Migration[6.1]
  def change
    return if column_exists?(:queued_tasks, :attempts)

    add_column :queued_tasks, :attempts, :integer, after: :weight
  end
end

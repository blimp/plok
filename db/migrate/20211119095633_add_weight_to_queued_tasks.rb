class AddWeightToQueuedTasks < ActiveRecord::Migration[6.1]
  def change
    return if column_exists?(:queued_tasks, :weight)

    add_column :queued_tasks, :weight, :integer, after: :locked, index: true
  end
end

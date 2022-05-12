class AddIndexToQueuedTaskWeight < ActiveRecord::Migration[6.1]
  def change
    return if index_exists?(:queued_tasks, :weight)

    add_index :queued_tasks, :weight
  end
end

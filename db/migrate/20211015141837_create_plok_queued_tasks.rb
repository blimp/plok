class CreatePlokQueuedTasks < ActiveRecord::Migration[6.1]
  def change
    return if table_exists?(:queued_tasks)

    create_table :queued_tasks do |t|
      t.string :klass
      t.text :data
      t.boolean :locked
      t.datetime :perform_at

      t.timestamps
    end
  end
end

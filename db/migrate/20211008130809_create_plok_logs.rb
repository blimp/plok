class CreatePlokLogs < ActiveRecord::Migration[6.1]
  def change
    return if table_exists?(:logs)

    create_table :logs do |t|
      t.string :category
      t.string :loggable_type
      t.integer :loggable_id
      t.string :file
      t.text :content
      t.text :data

      t.timestamps
    end
  end
end

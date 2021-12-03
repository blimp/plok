class AddFileToLogs < ActiveRecord::Migration[6.1]
  def change
    return if column_exists?(:logs, :file)

    add_column :logs, :file, :string, after: :loggable_id
  end
end

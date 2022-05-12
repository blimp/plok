class AddLogIndexesToCategoryTypeAndId < ActiveRecord::Migration[6.1]
  def change
    add_index :logs, :category unless index_exists?(:logs, :category)
    add_index :logs, :loggable_type unless index_exists?(:logs, :loggable_type)
    add_index :logs, :loggable_id unless index_exists?(:logs, :loggable_id)
  end
end

# This migration originally comes from udongo_engine
class CreateSearchModules < ActiveRecord::Migration[6.1]
  def change
    return if table_exists?(:search_modules)

    create_table :search_modules do |t|
      t.string :name
      t.boolean :searchable
      t.integer :weight

      t.timestamps
    end

    add_index :search_modules, [:name, :searchable]
  end
end

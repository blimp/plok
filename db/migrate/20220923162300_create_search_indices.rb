# This migration originally comes from udongo_engine
class CreateSearchIndices < ActiveRecord::Migration[6.1]
  def change
    return if table_exists?(:search_indices)

    create_table :search_indices do |t|
      t.string :searchable_type
      t.integer :searchable_id
      t.string :locale, index: true
      t.string :name
      t.text :value

      t.timestamps
    end

    add_index :search_indices, [:searchable_type, :searchable_id]
    add_index :search_indices, [:locale, :name]
  end
end

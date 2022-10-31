class AddNamespaceToSearchIndices < ActiveRecord::Migration[6.1]
  def change
    add_column :search_indices, :namespace, :string, after: :searchable_id, index: true
  end
end

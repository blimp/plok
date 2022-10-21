class RenameNameToKlassForSearchModules < ActiveRecord::Migration[6.1]
  def up
    rename_column :search_modules, :name, :klass
  end

  def down
    rename_column :search_modules, :klass, :name
  end
end

class AddImporterToSpreeImports < ActiveRecord::Migration
  def change
    add_column :spree_imports, :importer, :string
  end
end

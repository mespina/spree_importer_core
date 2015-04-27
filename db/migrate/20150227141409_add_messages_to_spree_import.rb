class AddMessagesToSpreeImport < ActiveRecord::Migration
  def change
    add_column :spree_imports, :messages, :text
  end
end

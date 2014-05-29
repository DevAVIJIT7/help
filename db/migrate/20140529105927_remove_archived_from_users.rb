class RemoveArchivedFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :archived, :boolean
  end
end

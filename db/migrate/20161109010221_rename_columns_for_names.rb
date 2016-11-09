class RenameColumnsForNames < ActiveRecord::Migration[5.0]
  def change
    rename_column :races, :democrat_name, :first_name
    rename_column :races, :republican_name, :second_name
    rename_column :races, :democrat_votes, :first_votes
    rename_column :races, :republican_votes, :second_votes
  end
end

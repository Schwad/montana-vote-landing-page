class AddColumnsForRace < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :democrat_name, :text
    add_column :races, :republican_name, :text
    add_column :races, :race_name, :text
    add_column :races, :house, :boolean
    add_column :races, :democrat_votes, :integer, default: 0
    add_column :races, :republican_votes, :integer, default: 0
    add_column :races, :leader, :text
    add_column :races, :lead_changes, :integer, default: 0
  end
end

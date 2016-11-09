class AddColumnsToTotalCount < ActiveRecord::Migration[5.0]
  def change
    add_column :total_counts, :republican_senate, :integer, default: 0
    add_column :total_counts, :republican_house, :integer, default: 0
    add_column :total_counts, :democrat_senate, :integer, default: 0
    add_column :total_counts, :democrat_house, :integer, default: 0
  end
end

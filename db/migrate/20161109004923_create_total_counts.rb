class CreateTotalCounts < ActiveRecord::Migration[5.0]
  def change
    create_table :total_counts do |t|

      t.timestamps
    end
  end
end

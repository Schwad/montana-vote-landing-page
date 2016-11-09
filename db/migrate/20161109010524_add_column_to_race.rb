class AddColumnToRace < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :first_party, :text
    add_column :races, :second_party, :text
  end
end

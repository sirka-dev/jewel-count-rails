class DropTableCounts < ActiveRecord::Migration[5.0]
  def change
    drop_table :counts
  end
end

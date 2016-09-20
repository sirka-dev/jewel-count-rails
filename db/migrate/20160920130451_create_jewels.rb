class CreateJewels < ActiveRecord::Migration[5.0]
  def change
    create_table :jewels do |t|
      t.integer :count, :null => false
      t.datetime :date, :null => false
      t.boolean :delflag, :null => false, :default => false
      t.boolean :syncflag, :null => false, :default => false

      t.timestamps
    end
  end
end

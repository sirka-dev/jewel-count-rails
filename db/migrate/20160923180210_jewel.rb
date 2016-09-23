class Jewel < ActiveRecord::Migration[5.0]
  def change
    add_column :jewels, :usage, :string, default:"ライブ"
  end
end

class AddDefaultValueForUserPoints < ActiveRecord::Migration
  def change
    change_column_default(:users,:points,10)
  end
end

class ChangeDateTypeInDaysOff < ActiveRecord::Migration
  def up
    change_column :days_off, :date, :string
  end

  def down
    change_column :days_off, :date, :date
  end
end

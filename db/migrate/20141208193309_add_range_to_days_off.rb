class AddRangeToDaysOff < ActiveRecord::Migration
  def change
    add_column :days_off, :range, :string
  end
end

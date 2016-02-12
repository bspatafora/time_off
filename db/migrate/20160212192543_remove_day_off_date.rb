class RemoveDayOffDate < ActiveRecord::Migration
  def change
    remove_column :days_off, :date, :string
  end
end

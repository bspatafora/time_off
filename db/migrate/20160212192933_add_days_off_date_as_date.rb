class AddDaysOffDateAsDate < ActiveRecord::Migration
  def change
    add_column :days_off, :date, :date
  end
end

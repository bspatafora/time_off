class AddUrlToDaysOff < ActiveRecord::Migration
  def change
    add_column :days_off, :url, :string
  end
end

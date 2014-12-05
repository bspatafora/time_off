class AddEventIdToDaysOff < ActiveRecord::Migration
  def change
    add_column :days_off, :event_id, :string
  end
end

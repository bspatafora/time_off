class CreateDaysOff < ActiveRecord::Migration
  def change
    create_table :days_off do |t|
      t.integer :user_id
      t.date :date
      t.string :category

      t.timestamps
    end
  end
end

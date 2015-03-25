class AddFlexDaysRemainingIn2014 < ActiveRecord::Migration
  def change
    add_column :users, :flex_days_remaining_in_2014, :integer, default: 0
    User.update_all(flex_days_remaining_in_2014: 0)
  end
end

class User < ActiveRecord::Base
  has_many :days_off, dependent: :destroy
end

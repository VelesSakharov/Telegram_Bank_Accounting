class Account < ApplicationRecord
  has_many :costs
  belongs_to :user
end

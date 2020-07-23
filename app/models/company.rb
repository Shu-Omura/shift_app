class Company < ApplicationRecord
  has_many :users
  has_secure_token :auth_token
end

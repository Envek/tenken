class Site < ApplicationRecord
  has_many :checks, dependent: :destroy, class_name: '::Check'
end

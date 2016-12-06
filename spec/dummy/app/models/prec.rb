class Prec < ActiveRecord::Base
  has_many :drecs
  accepts_nested_attributes_for :drecs
end

class ParentRecord < ActiveRecord::Base
  has_many :nd_workflows
  accepts_nested_attributes_for :nd_workflows
end

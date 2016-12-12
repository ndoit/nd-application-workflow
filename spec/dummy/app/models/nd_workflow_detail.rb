require 'acts_as_nd_application_workflow_detail'

class NdWorkflowDetail < ActiveRecord::Base
  belongs_to :nd_workflow
  acts_as_nd_application_workflow_detail

  @@DETAIL_DATA_LABELS = {
    'JV' => 'Fund'
  }
  @@DETAIL_KEY_DESCRIPTIONS = {
    'OVERLIMIT' => 'Amount exceeds predefined limit'
  }

end

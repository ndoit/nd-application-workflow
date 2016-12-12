class NdWorkflowDetail < ActiveRecord::Base
  belongs_to :nd_workflow

  @@DETAIL_DATA_LABELS = {
    'JV' => 'Fund'
  }
  @@DETAIL_KEY_DESCRIPTIONS = {
    'OVERLIMIT' => 'Amount exceeds predefined limit'
  }

  def detail_data_label
    @@DETAIL_DATA_LABELS[detail_type]
  end

  def detail_key_description
    @@DETAIL_KEY_DESCRIPTIONS[detail_key]
  end
end

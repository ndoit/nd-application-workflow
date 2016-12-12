class ParentRecord < ActiveRecord::Base
  has_many :nd_workflows
  accepts_nested_attributes_for :nd_workflows
  validates :parent_desc, presence: true

  # Add an automatic approval_notes
  def add_auto_approvals
    app = self.nd_workflows.create(workflow_type: 'approval', auto_or_manual: 'auto', assigned_to_netid: 'HR', assigned_to_first_name: 'Human Resources')
    app_d = app.nd_workflow_details.create( detail_type: 'JV', detail_data: '100000', detail_key: 'OVERLIMIT')
    app_d = app.nd_workflow_details.create( detail_type: 'SEP', detail_desc: 'Automatic routing')
  end
end

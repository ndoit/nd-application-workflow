require 'acts_as_nd_application_workflow'

class NdWorkflow < ActiveRecord::Base
  belongs_to :parent_record
  has_many :nd_workflow_details
  acts_as_nd_application_workflow

  include Workflow
  @@WORKFLOW_STATE_DESC['created'] = 'Pending';
  #Workflow provided by the workflow gem.
  workflow do
    state :created do
      event :email_sent, :transitions_to => :emailed
      event :submit, :transitions_to => :submitted, :unless => proc {  |wf| wf.is_approval? }
      event :submit, :transitions_to => :pending_approval, :if => proc {  |wf| wf.is_approval? }
      event :return, :transitions_to => :returned_for_correction
      event :void, :transitions_to => :voided
    end
    state :returned_for_correction do
      event :email_sent, :transitions_to => :emailed
      event :return, :transitions_to => :returned_for_correction
      event :void, :transitions_to => :voided
    end
    state :pending_approval do
      event :approve, :transitions_to => :approved
      event :return, :transitions_to => :returned_for_correction
      event :email_sent, :transitions_to => :emailed
    end
    state :emailed do
      event :approve, :transitions_to => :approved
      event :return, :transitions_to => :returned_for_correction
      event :email_sent, :transitions_to => :emailed
    end
    state :approved do
      event :approve, :transitions_to => :approved
      event :email_sent, :transitions_to => :emailed
    end
    state :submitted do
      event :submit, :transitions_to => :submitted
      event :approve, :transitions_to => :approved
    end
    state :voided do
      event :submit, :transitions_to => :submitted, :unless => proc {  |wf| wf.is_approval? }
      event :submit, :transitions_to => :pending_approval, :if => proc {  |wf| wf.is_approval? }
    end
  end
end

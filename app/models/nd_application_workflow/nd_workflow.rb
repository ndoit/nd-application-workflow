module NdApplicationWorkflow
  class NdWorkflow < ActiveRecord
    include Workflow

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
        event :void, :transitions_to => :voided
      end
      state :emailed do
        event :approve, :transitions_to => :approved
        event :return, :transitions_to => :returned_for_correction
        event :email_sent, :transitions_to => :emailed
        event :void, :transitions_to => :voided
      end
      state :approved do
        event :approve, :transitions_to => :approved
        event :email_sent, :transitions_to => :emailed
        event :void, :transitions_to => :voided
      end
      state :submitted do
        event :submit, :transitions_to => :submitted
        event :approve, :transitions_to => :approved
        event :void, :transitions_to => :voided
    end
      state :voided

    end


    def is_submitter_approval?
        workflow_type == 'approval' && auto_or_manual = 'manual'
    end

    def is_approval?
       workflow_type = 'approval'
    end

    def approve( user_id,notes)
      self.approved_by = user_id
      self.approved_date = Date.today
      self.approval_notes = notes
    end

    @@WORKFLOW_STATE_DESC = {
      'new'             => 'Empty',
      'created'         => 'Pending Submission',
      'emailed'         => 'Email Sent',
      'submitted'       => 'Submitted',
      'pending_approval' => 'Submitted',
      'approved'        => 'Approved',
      'voided'          => 'Voided',
      'returned_for_correction' => 'Pending Submission',
      'saved' => 'Saved'
    }

    def workflow_state_description
      @@WORKFLOW_STATE_DESC[self.workflow_state]
    end

    @@WORKFLOW_TYPE_DESC = {
      'fyi'      => 'Notification',
      'approval'   => 'Approval',
      'task' => 'Task',
    }

    def workflow_type_description
      @@WORKFLOW_TYPE_DESC[self.workflow_type]
    end

  end
end

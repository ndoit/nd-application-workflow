module ActsAsNdApplicationWorkflow

  module ClassMethods
    def acts_as_nd_application_workflow(options = {})
      include ActsAsNdApplicationWorkflow::InstanceMethods
    end
  end

  module InstanceMethods
    # Rates the object by a given score. A user object should be passed to the method.
    def is_submitter_approval?
        workflow_type == 'approval' && auto_or_manual = 'manual'
    end

    def is_approval?
       workflow_type == 'approval'
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
      'approval' => 'Approval',
      'task'     => 'Task',
      'reminder' => 'Separation Instructions',
    }

    def workflow_type_description
      @@WORKFLOW_TYPE_DESC[self.workflow_type]
    end


  end


end

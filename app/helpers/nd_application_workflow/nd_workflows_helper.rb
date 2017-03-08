module NdApplicationWorkflow
  module NdWorkflowsHelper

    def nd_workflows_attributes
      [ :id, :workflow_type, :auto_or_manual, :workflow_custom_type, :assigned_to_netid,
        :assigned_to_first_name, :assigned_to_last_name, :email_notes, :email_include_detail,
        :approval_notes, :approved_date, :approved_by_netid, :created_by_netid, :workflow_state,
        :nd_workflow_details_attributes => nd_workflow_details_attributes ]
    end

    def nd_workflow_details_attributes
      [
        :id,
        :employee_id,
        :pidm,
        :posn,
        :suffix,
        :employee_class,
        :primary,
        :start_date,
        :end_date,
        :title,
        :status,
        :status_description,
        :last_paid,
        :orgn_code,
        :orgn_title,
        :pict_code ]
    end

    def american_date(delivery_date)
      unless delivery_date.blank?
        delivery_date.strftime('%m/%d/%Y')
      else
        ''
      end
    end
  end
end

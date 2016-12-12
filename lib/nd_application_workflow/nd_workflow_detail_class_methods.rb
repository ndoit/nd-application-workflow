module ActsAsNdApplicationWorkflowDetail

  module ClassMethods
    def acts_as_nd_application_workflow_detail(options = {})
      include ActsAsNdApplicationWorkflowDetail::InstanceMethods
    end
  end

  module InstanceMethods
    @@DETAIL_DATA_LABELS = {
    }
    @@DETAIL_KEY_DESCRIPTIONS = {
    }

    def detail_data_label
      @@DETAIL_DATA_LABELS[detail_type]
    end

    def detail_key_description
      @@DETAIL_KEY_DESCRIPTIONS[detail_key]
    end

  end


end

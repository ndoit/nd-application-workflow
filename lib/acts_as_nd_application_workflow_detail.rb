require 'nd_application_workflow/nd_workflow_detail_class_methods'

module ActsAsNdApplicationWorkflowDetail
  def self.included(mod)
    mod.extend(ClassMethods)
  end

end

ActiveRecord::Base.class_eval do
  include ActsAsNdApplicationWorkflowDetail
end

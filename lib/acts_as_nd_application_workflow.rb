require 'nd_application_workflow/nd_workflow_class_methods'

module ActsAsNdApplicationWorkflow
  def self.included(mod)
    mod.extend(ClassMethods)
  end

end

ActiveRecord::Base.class_eval do
  include ActsAsNdApplicationWorkflow
end

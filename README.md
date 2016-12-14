# NdApplicationWorkflow #

This Rails plug in provides a framework for setting up and processing workflows within an application.  A ZURB Foundation modal reveal form is provided along with the ability to lookup ND employees to be assigned workflow.  Workflow can be defined as three types: fyi, approval, or task.

### Installation ###

Add the following to your Gemfile, then run ```bundle install```
```
gem 'dotenv' # if does not already exist
gem 'cocoon' # if does not already exist
gem 'workflow' # if does not already exist
gem 'nd_employee_lookup', '~> 0.2.0', git: 'git@bitbucket.org:nd-oit/nd-employee-lookup-gem.git', tag: 'v0.2.3'  # if does not already exist
gem 'nd_application_workflow', '~> 0.1.0', git: 'git@bitbucket.org:nd-oit/nd-application-workflow.git', tag: 'v0.1.0'
```

Add following to application.js
```
//= require cocoon  # if does not already exist
//= require nd_application_workflow/application_workflow
```

Run rake nd_application_workflow:install:migrations

- Edit the create_nd_workflows migration to change :<parent id> to a field name to
tie the workflow to its parent document (i.e. change :<parent id> to :financial_document_id

- Run rake db:migrate


### Setup ###


You may want to add the following to your application css file
```
.nd_workflow_name {  font-weight: bold; }
.nd_workflow_netid {  font-weight: bold; }
div.ndwf_list {	background-color: #fff;	border-bottom: 1px #ddd solid;	color: #000; }
div.ndwf_list:hover { background-color: #faf2c0; cursor: pointer; }
```
** if you do not already have a css class for ajax-processing, you may want to add one
with a background spinner image


### Plug in partials ###

** to have the nd_workflow.created_by_netid field set for manual notifications, add
the following to your form ** replace session.user_netid with the appropriate session variable in your application: 
```
<input type="hidden" id="nd_workflow_current_user_id" name="nd_workflow_current_user_netid" value="<%= session.user_netid %>">
```

- nd_application_workflow/workflow_employee_lookup_reveal 
-- include in pages from which the user can add notifications
-- see example in spec/dummmy/app/views/parent_records/_form.html.erb

- nd_application_workflow/workflow_fields_display 
-- use in edit forms to display workflows that cannot be changed by the user (i.e. do not allow modification to workflows created by a different user)
-- locals: :f => <nd_workflow instance>, output_type_description: <true|false>, output_custom_type_description: <true|false>
-- see example in spec/dummy/app/views/parent_records/_form.html.erb

- nd_application_workflow/workflow_approval_and_fyi 
-- use in edit forms to display for editing workflows that can be changed by the user
-- locals: :f => <nd_workflow instance>, nd_workflow_approval_available: <true|false>
-- see example in spec/dummy/app/views/parent_records/_form.html.erb

- nd_application_workflow/workflow_routing_queue 
-- use in show forms to display the workflow
-- locals: p: <parent record instance>, output_custom_type_description: <true|false>, output_type_description: <true|false>, using_nd_workflow_details: <true|false>
-- see example in spec/dummy/app/views/parent_records/show.html.erb

### Add workflow button ###
To work properly, you need a visible button on your form with the id b_add_nd_workflow.  You also need a hidden link_to_add_association. The following code provides an example.
'''  <div class="row"><div class="large-4 medium-5 small-6 left column">
    <!-- link_to_add_association functionality comes from the cocoon gem -->
    <%= link_to add_button_label, "javascript: void(0);", class: "button small", id: "b_add_nd_workflow" %>
  </div></div>
  <div style="display: none;">
    <%= link_to_add_association add_button_label, form, :nd_workflows, { :partial => "/nd_application_workflow/workflow_approval_and_fyi", "data-association-insertion-node" => "#nd_workflow_list", "data-association-insertion-method" => "append", :class => "button small", :id => "b_nd_workflow_insert", render_options: {locals: { nd_workflow_approval_available: false}} } %>
  </div>
```

### acts_as_nd_application_workflow ###


- NdWorkflow instance method is_submitter_approval?  (where workflow_type == approval && auto_or_manual = manual)

- NdWorkflow instance method is_approval? (where workflow_type = approval)

- NdWorkflow instance method approve(user_id,notes) sets approved_by,approved_date and approval_notes

- @@WORKFLOW_STATE_DESC hash with the following: 
      'new'             => 'Empty',
      'created'         => 'Pending Submission',
      'emailed'         => 'Email Sent',
      'submitted'       => 'Submitted',
      'pending_approval' => 'Submitted',
      'approved'        => 'Approved',
      'voided'          => 'Voided',
      'returned_for_correction' => 'Pending Submission',
      'saved' => 'Saved'
- NdWorkflow instance method workflow_type_description which returns the workflow_state mapped value of @@WORKFLOW_TYPE_DESC 
** if you need to add or modify @@WORKFLOW_STATE_DESC you can edit/add to the hash in your model like this:
  @@WORKFLOW_STATE_DESC['created'] = 'Pending';
  
- NdWorkflow instance method workflow_type_description using the hash
  @@WORKFLOW_TYPE_DESC = {
      'fyi'      => 'Notification',
      'approval'   => 'Approval',
      'task' => 'Task',
    }

### acts_as_nd_application_workflow_detail ###

- NdWorkflowDetail instance method detail_data_label  uses detail_type to map to the appropriate detail_data label from @@DETAIL_DATA_LABELS **you define this hash**

- NdWorkflowDetail instance method detail_key_description  uses detail_key to mape to the appropriate description from @@DETAIL_KEY_DESCRIPTIONS ** you define this hash**

### Example NdWorkflow model ###
*** Your application must have an NDWorkflow model ***
```
# app/models/nd_workflow.rb

require 'acts_as_nd_application_workflow'
class NdWorkflow < ActiveRecord::Base
  belongs_to :parent_record
  has_many :nd_workflow_details
  acts_as_nd_application_workflow

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
```
### Example NdWorkflowDetail model ###
*** Your application must have an NDWorkflowDetail model ***
```
# app/models/nd_workflow_detail.rb
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
```
### Example ParentRecord model ###
*** Your application must have a parent record model as appropriate for your application ***
```
# app/models/parent_record.rb
class ParentRecord < ActiveRecord::Base
  has_many :nd_workflows
  accepts_nested_attributes_for :nd_workflows
  has_many :manual_workflows, -> { where( "auto_or_manual = 'manual'")}, :class_name => "NdWorkflow"
  accepts_nested_attributes_for :manual_workflows

  # Add an automatic approval_notes
  def add_auto_approvals
    app = self.nd_workflows.create(workflow_type: 'approval', auto_or_manual: 'auto', assigned_to_netid: 'HR', assigned_to_first_name: 'Human Resources')
    app_d = app.nd_workflow_details.create( detail_type: 'JV', detail_data: '100000', detail_key: 'OVERLIMIT')
    app_d = app.nd_workflow_details.create( detail_type: 'SEP', detail_desc: 'Automatic routing')
  end
end
```

### Who do I talk to? ###

* Teresa Meyer (tmeyer2@nd.edu) or CITS Employee Finance
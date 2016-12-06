# This migration comes from nd_application_workflow (originally 20161205134027)
class CreateNdWorkflowDetails < ActiveRecord::Migration
  def change
    create_table :nd_workflow_details do |t|
      t.integer :nd_workflow_id
      t.string :detail_data
      t.string :detail_key
      t.string :detail_desc

      t.timestamps null: false
    end
  end
end

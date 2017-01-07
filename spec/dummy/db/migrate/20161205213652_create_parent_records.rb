class CreateParentRecords < ActiveRecord::Migration
  def change
    create_table :parent_records do |t|
      t.string :parent_desc
      t.boolean :nd_workflow_approval_available
      t.boolean :nd_workflow_include_email_detail_cb
      t.timestamps null: false
    end
  end
end

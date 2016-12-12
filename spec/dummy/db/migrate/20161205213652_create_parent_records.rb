class CreateParentRecords < ActiveRecord::Migration
  def change
    create_table :parent_records do |t|
      t.string :parent_desc
      t.boolean :nd_workflow_approval_available
      t.timestamps null: false
    end
  end
end

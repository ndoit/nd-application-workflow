class CreateNdWorkflows < ActiveRecord::Migration
  def change
    create_table :nd_workflows do |t|
      t.integer :<parent_id>
      # change the above to the table name of the parent (i.e. financial_document)
      t.string :workflow_type
      # i.e. approval, fyi, task
      t.string :auto_or_manual
      t.string :workflow_custom_type
      # use to set types specific to your app
      t.string :assigned_to_netid
      t.string :assigned_to_first_name
      t.string :assigned_to_last_name
      t.text :email_notes
      t.boolean :email_include_detail
      t.text :approval_notes
      t.date :approved_date
      t.string :approved_by_netid

      t.string :workflow_state

      t.timestamps null: false
    end
  end
end

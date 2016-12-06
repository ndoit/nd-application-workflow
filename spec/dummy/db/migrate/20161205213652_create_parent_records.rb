class CreateParentRecords < ActiveRecord::Migration
  def change
    create_table :parent_records do |t|
      t.string :parent_desc

      t.timestamps null: false
    end
  end
end

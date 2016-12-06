class CreateDrecs < ActiveRecord::Migration
  def change
    create_table :drecs do |t|
      t.integer :prec_id
      t.string :drec_desc

      t.timestamps null: false
    end
  end
end

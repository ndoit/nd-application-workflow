class CreatePrecs < ActiveRecord::Migration
  def change
    create_table :precs do |t|
      t.string :prec_desc

      t.timestamps null: false
    end
  end
end

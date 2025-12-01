class CreateAppchatFunctions < ActiveRecord::Migration[7.2]
  def change
    create_table :appchat_functions do |t|
      t.string :name
      t.text :description
      t.string :class_name

      t.timestamps
    end
  end
end

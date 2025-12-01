class CreateFunctionLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :function_logs do |t|
      t.references :message, null: false, foreign_key: true
      t.string :name
      t.text :prompt
      t.text :results

      t.timestamps
    end
  end
end

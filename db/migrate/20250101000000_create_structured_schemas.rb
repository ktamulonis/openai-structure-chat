class CreateStructuredSchemas < ActiveRecord::Migration[7.1]
  def change
    create_table :structured_schemas do |t|
      t.string :name, null: false
      # This is the name OpenAI sees in text.format.name
      t.string :openai_name, null: false
      t.string :model, null: false, default: "gpt-5.1"
      t.text   :description

      t.timestamps
    end

    add_index :structured_schemas, :openai_name, unique: true
  end
end

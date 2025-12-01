class CreateStructuredFields < ActiveRecord::Migration[7.1]
  def change
    create_table :structured_fields do |t|
      t.references :structured_schema, null: false, foreign_key: true

      t.string  :key, null: false                      # e.g. "name", "species"
      t.string  :data_type, null: false, default: "string"
      # "string", "integer", "number", "boolean", "array", "enum"

      t.boolean :required, null: false, default: true

      # used when data_type == "array"
      t.string  :item_type

      # used when data_type == "enum" (comma-separated or JSON)
      t.text    :enum_values

      t.integer :position
      t.string  :description

      t.timestamps
    end
  end
end

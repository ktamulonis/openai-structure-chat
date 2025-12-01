require 'rails_helper'

RSpec.describe StructuredSchema, type: :model do
  let(:schema) do
    StructuredSchema.create!(
      name: "Pet Description",
      openai_name: "PetDescription",
      model: "gpt-5.1"
    )
  end

  describe "OpenAI schema validations" do
    it "is valid with proper fields" do
      schema.structured_fields.create!(key: "name", data_type: "string", required: true)
      schema.structured_fields.create!(key: "age_years", data_type: "integer", required: true)
      schema.structured_fields.create!(key: "temperament", data_type: "enum", enum_values: "friendly,shy", required: true)

      expect(schema).to be_valid
    end

    it "rejects enum fields that are not required" do
      schema.structured_fields.create!(key: "temperament", data_type: "enum", enum_values: "friendly,shy", required: false)

      expect(schema).not_to be_valid
      expect(schema.errors[:base]).to include("enum field 'temperament' must be required")
    end

    it "rejects array fields that are not required" do
      schema.structured_fields.create!(key: "likes", data_type: "array", item_type: "string", required: false)

      expect(schema).not_to be_valid
      expect(schema.errors[:base]).to include("array field 'likes' must be required")
    end

    it "rejects schemas where enum fields are not required" do
      schema = StructuredSchema.create!(
        name: "TestSchema",
        openai_name: "TestSchema",
        model: "gpt-5.1"
      )

      schema.structured_fields.create!(
        key: "color",
        data_type: "enum",
        enum_values: "red,blue,green",
        required: false # invalid, must be required
      )

      schema.validate

      expect(schema.errors[:base]).to include(
        "enum field 'color' must be required"
      )
    end


    it "requires at least one required field when fields exist" do
      schema.structured_fields.create!(key: "name", data_type: "string", required: false)

      expect(schema).not_to be_valid
      expect(schema.errors[:base]).to include("at least one field must be required")
    end
  end

  describe "#to_json_schema" do
    it "produces correct JSON schema" do
      schema.structured_fields.create!(key: "name", data_type: "string", required: true)
      schema.structured_fields.create!(key: "age_years", data_type: "integer", required: true)

      json = schema.to_json_schema

      expect(json[:type]).to eq("object")
      expect(json[:additionalProperties]).to eq(false)
      expect(json[:properties].keys).to include("name", "age_years")
      expect(json[:required]).to eq([ "name", "age_years" ])
    end
  end
end

require 'rails_helper'

RSpec.describe StructuredField, type: :model do
  let(:schema) { StructuredSchema.create!(name: "Test", openai_name: "TestSchema", model: "gpt-5.1") }

  describe "validations" do
    it "requires a key" do
      field = schema.structured_fields.build(key: nil, data_type: "string")
      expect(field).not_to be_valid
      expect(field.errors[:key]).to include("can't be blank")
    end

    it "rejects invalid key formats" do
      field = schema.structured_fields.build(key: "invalid-key!", data_type: "string")
      expect(field).not_to be_valid
      expect(field.errors[:key]).to include("must be a valid JSON key (letters, numbers, underscore)")
    end

    it "requires a valid data_type" do
      field = schema.structured_fields.build(key: "abc", data_type: "bad_type")
      expect(field).not_to be_valid
      expect(field.errors[:data_type])
        .to include("must be one of: string, integer, float, boolean, enum, array, object")
    end

    context "enum type" do
      it "requires enum_values" do
        field = schema.structured_fields.build(key: "temperament", data_type: "enum", enum_values: nil)
        expect(field).not_to be_valid
        expect(field.errors[:enum_values]).to include("cannot be blank for enum fields")
      end
    end

    context "array type" do
      it "requires item_type" do
        field = schema.structured_fields.build(key: "tags", data_type: "array", item_type: nil)
        expect(field).not_to be_valid
        expect(field.errors[:item_type]).to include("is required for array fields")
      end
    end
  end
end

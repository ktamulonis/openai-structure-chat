require 'rails_helper'

RSpec.describe OpenaiSchemaValidator do
  let(:schema) do
    StructuredSchema.create!(
      name: "TestSchema",
      openai_name: "TestSchema",
      model: "gpt-5.1"
    )
  end

  it "passes valid schemas" do
    schema.structured_fields.create!(key: "name", data_type: "string", required: true)

    expect {
      OpenaiSchemaValidator.validate!(schema)
    }.not_to raise_error
  end
  it "raises error for invalid schemas" do
    # Valid field, but schema is invalid because no fields are required
    schema.structured_fields.create!(key: "name", data_type: "string", required: false)

    expect {
      OpenaiSchemaValidator.validate!(schema)
    }.to raise_error(/OpenAI Schema Error/)
  end
end

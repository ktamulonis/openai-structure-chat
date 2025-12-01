class OpenaiSchemaValidator
  def self.validate!(schema)
    client = OPENAI_CLIENT

    test = client.responses.create(
      model: "gpt-5.1",
      input: "test",
      text: {
        format: {
          name: "SchemaTest",
          type: "json_schema",
          schema: schema.to_json_schema
        }
      }
    )

    true
  rescue OpenAI::Errors::BadRequestError => e
    raise "OpenAI Schema Error: #{e.message}"
  end
end

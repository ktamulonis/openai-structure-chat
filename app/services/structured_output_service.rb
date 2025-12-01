# frozen_string_literal: true

class StructuredOutputService
  Result = Struct.new(:parsed, :json_text, :raw, keyword_init: true)

  def initialize(prompt:, structured_schema:, client: default_client)
    @prompt = prompt
    @structured_schema = structured_schema
    @client = client
  end

  def call
    response = @client.responses.create(
      model: @structured_schema.model,
      input: @prompt,
      text: {
        format: {
          name: @structured_schema.openai_name,
          type: "json_schema",
          schema: @structured_schema.to_json_schema
        }
      }
    )

    message     = response.output.first
    json_string = message.content.first.text
    parsed      = JSON.parse(json_string)

    Result.new(
      parsed: parsed,
      json_text: json_string,
      raw: response
    )
  end

  private

  def default_client
    OPENAI_CLIENT
  end
end

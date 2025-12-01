# app/jobs/get_ai_response_job.rb
class GetAiResponseJob < ApplicationJob
  queue_as :default

  def perform(chat_id, user_prompt)
    chat = Chat.find(chat_id)

    # Create the assistant message placeholder
    message = chat.messages.create!(role: :assistant)

    schema = chat.structured_schema
    prompt = user_prompt

    # -----------------------------
    # STRUCTURED OUTPUT MODE ALWAYS
    # -----------------------------
    result = StructuredOutputService.new(
      prompt: prompt,
      structured_schema: schema
    ).call

    message.update!(
      content: JSON.pretty_generate(result.parsed),
    )
  end
end

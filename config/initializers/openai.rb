# config/initializers/openai.rb
# frozen_string_literal: true

OPENAI_CLIENT = OpenAI::Client.new(
  api_key: Rails.application.credentials.dig(:openai, :api_key)
)

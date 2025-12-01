FactoryBot.define do
  factory :structured_schema do
    name { "Example Schema" }
    openai_name { "ExampleSchema" }
    model { "gpt-5.1" }
  end
end

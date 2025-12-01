FactoryBot.define do
  factory :structured_field do
    key { "name" }
    data_type { "string" }
    required { true }
    association :structured_schema
  end
end

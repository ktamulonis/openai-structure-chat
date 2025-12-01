# app/models/structured_field.rb
class StructuredField < ApplicationRecord
  belongs_to :structured_schema

  #
  # -------------------------------
  # VALIDATIONS (OpenAI-compatible)
  # -------------------------------
  #

  # JSON-safe key
  validates :key,
            presence: true,
            format: {
              with: /\A[a-zA-Z_][a-zA-Z0-9_]*\z/,
              message: "must be a valid JSON key (letters, numbers, underscore)"
            }

  # Supported types
  VALID_DATA_TYPES = %w[
    string
    integer
    float
    boolean
    enum
    array
    object
  ].freeze

  validates :data_type,
            presence: true,
            inclusion: {
              in: VALID_DATA_TYPES,
              message: "must be one of: #{VALID_DATA_TYPES.join(', ')}"
            }

  # Enum must have values
  validate :validate_enum_values

  # Array must specify item type
  validate :validate_array_item_type

  # Object validation (currently free-form)
  validate :validate_object_rules

  #
  # -------------------------------
  # SCHEMA GENERATOR
  # -------------------------------
  #

  def to_schema
    case data_type
    when "string"
      { type: "string" }

    when "integer"
      { type: "integer" }

    when "float"
      { type: "number" }

    when "boolean"
      { type: "boolean" }

    when "enum"
      {
        type: "string",
        enum: enum_values.split(",").map(&:strip)
      }

    when "array"
      {
        type: "array",
        items: { type: item_type || "string" }
      }

    when "object"
      # Simple free-form objects allowed for now
      {
        type: "object",
        additionalProperties: true
      }

    else
      { type: "string" }
    end
  end

  #
  # -------------------------------
  # PRIVATE VALIDATION HELPERS
  # -------------------------------
  #
  private

  #
  # ENUM FIELD RULES
  #
  def validate_enum_values
    return unless data_type == "enum"

    if enum_values.blank?
      errors.add(:enum_values, "cannot be blank for enum fields")
    end
  end

  #
  # ARRAY FIELD RULES
  #
  def validate_array_item_type
    return unless data_type == "array"

    if item_type.blank?
      errors.add(:item_type, "is required for array fields")
    end

    unless item_type.in?(%w[string integer float boolean])
      errors.add(:item_type, "must be a primitive JSON type")
    end
  end

  #
  # OBJECT RULES (OpenAI limits)
  #
  def validate_object_rules
    return unless data_type == "object"

    # Currently OpenAI allows free-form objects (with additionalProperties: true)
    # but we can still enforce that object fields are not required by schema-level rules.
    # More detailed validation can be added later.
    true
  end
end

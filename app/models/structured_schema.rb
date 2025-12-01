class StructuredSchema < ApplicationRecord
  has_many :structured_fields, -> { order(:position, :id) }, dependent: :destroy

  validate :validate_openai_schema

  #
  # ============================
  # JSON SCHEMA FOR OPENAI
  # ============================
  #
  def to_json_schema
    fields = structured_fields.to_a

    properties = fields.each_with_object({}) do |field, h|
      h[field.key] = field_schema(field)
    end

    required_keys = fields.select(&:required?).map(&:key)

    {
      type: "object",
      additionalProperties: false,
      properties: properties.presence || {},
      required: required_keys.presence || []
    }
  end

  private

  #
  # FIELD SCHEMA BUILDER
  #
  def field_schema(field)
    case field.data_type
    when "string"
      { type: "string" }

    when "integer"
      { type: "integer" }

    when "number", "float"
      { type: "number" }

    when "boolean"
      { type: "boolean" }

    when "enum"
      {
        type: "string",
        enum: field.enum_values.to_s.split(",").map(&:strip).reject(&:blank?)
      }

    when "array"
      {
        type: "array",
        items: { type: field.item_type || "string" }
      }

    when "object"
      {
        type: "object",
        additionalProperties: true
      }

    else
      { type: "string" }
    end
  end

  #
  # ============================
  # OPENAI REQUIRED VALIDATION RULES
  # ============================
  #
  def validate_openai_schema
    fields = structured_fields.to_a

    field_keys    = fields.map(&:key)
    required_keys = fields.select(&:required?).map(&:key)

    #
    # 1. REQUIRED KEYS MUST BE PRESENT IN PROPERTIES
    #
    # NOTE:
    # "properties" == keys that produce a valid schema entry.
    #
    property_keys = fields.map(&:key)

    missing_required = required_keys - property_keys
    if missing_required.any?
      errors.add(:base, "required keys include fields not defined in properties")
      return
    end

    #
    # 2. ENUM FIELDS MUST BE REQUIRED & HAVE VALUES
    #
    fields.select { |f| f.data_type == "enum" }.each do |field|
      errors.add(:base, "enum field '#{field.key}' must be required") unless field.required?
      errors.add(:base, "enum field '#{field.key}' must define enum_values") if field.enum_values.blank?
    end

    #
    # 3. ARRAY FIELDS MUST BE REQUIRED
    #
    fields.select { |f| f.data_type == "array" }.each do |field|
      errors.add(:base, "array field '#{field.key}' must be required") unless field.required?
    end

    #
    # 4. AT LEAST ONE REQUIRED FIELD
    #
    if fields.any? && required_keys.empty?
      errors.add(:base, "at least one field must be required")
    end
  end
end

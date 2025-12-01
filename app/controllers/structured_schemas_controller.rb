class StructuredSchemasController < ApplicationController
  before_action :set_structured_schema, only: %i[
    show edit update destroy run edit_fields update_fields
  ]

  #
  # CRUD
  #
  def index
    @structured_schemas = StructuredSchema.order(:name)
  end

  def show
    @fields = @structured_schema.structured_fields
  end

  def new
    @structured_schema = StructuredSchema.new
  end

  def create
    @structured_schema = StructuredSchema.new(schema_params)

    if @structured_schema.save
      redirect_to @structured_schema, notice: "Structured schema created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @structured_schema.update(schema_params)
      redirect_to @structured_schema, notice: "Structured schema updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @structured_schema.destroy
    redirect_to structured_schemas_path, notice: "Structured schema deleted."
  end

  #
  # === RUN STRUCTURED OUTPUT AGAINST OPENAI ===
  #
  def run
    prompt = params[:prompt].presence || "Say hello with this schema."

    result = StructuredOutputService.new(
      prompt: prompt,
      structured_schema: @structured_schema
    ).call

    @parsed    = result.parsed
    @json_text = result.json_text
    @raw       = result.raw

    render :show
  rescue OpenAI::Errors::OpenAIError => e
    flash.now[:alert] = "OpenAI error: #{e.message}"
    render :show, status: :bad_request
  end

  #
  # === NEW: EDIT FIELDS IN MODAL ===
  #
  def edit_fields
    @fields = @structured_schema.structured_fields.order(:position, :id)
    render layout: false  # required for turbo-modal
  end

  #
  # === NEW: UPDATE FIELDS FROM MODAL ===
  #
  def update_fields
    @structured_schema = StructuredSchema.find(params[:id])

    params[:fields]&.each do |field_id, attrs|
      field = @structured_schema.structured_fields.find(field_id)
      field.update(attrs.permit(:key, :data_type, :enum_values, :item_type, :required))
    end

    if params[:new_field].present? && params[:new_field][:key].present?
      @structured_schema.structured_fields.create!(
        key: params[:new_field][:key],
        data_type: params[:new_field][:data_type],
        enum_values: params[:new_field][:enum_values],
        item_type: params[:new_field][:item_type],
        required: params[:new_field][:required].present?,
        position: @structured_schema.structured_fields.maximum(:position).to_i + 1
      )
    end

    chat = Chat.find_by(id: params[:chat_id])

    respond_to do |format|
      format.turbo_stream do
        streams = []

        if chat
          streams << turbo_stream.replace(
            "schema_panel_#{chat.id}",
            partial: "chats/schema_panel",
            locals: { chat: chat }
          )
        end

        streams << turbo_stream.remove("modal")

        render turbo_stream: streams
      end

      format.html { redirect_to @structured_schema }
    end
  end

  private

  #
  # === Helpers for update_fields ===
  #
  def update_existing_fields
    return unless params[:fields]

    params[:fields].each do |id, attrs|
      field = @structured_schema.structured_fields.find(id)
      field.update!(
        key:       attrs[:key],
        data_type: attrs[:data_type],
        required:  attrs[:required] == "1",
        enum_values: attrs[:enum_values],
        item_type:   attrs[:item_type]
      )
    end
  end

  def add_new_field_if_present
    nf = params[:new_field]
    return if nf.blank? || nf[:key].blank?

    @structured_schema.structured_fields.create!(
      key:         nf[:key],
      data_type:   nf[:data_type],
      required:    nf[:required] == "1",
      enum_values: nf[:enum_values],
      item_type:   nf[:item_type]
    )
  end

  #
  # shared
  #
  def set_structured_schema
    @structured_schema = StructuredSchema.find(params[:id])
  end

  def schema_params
    params.require(:structured_schema).permit(
      :name, :openai_name, :model, :description
    )
  end
end

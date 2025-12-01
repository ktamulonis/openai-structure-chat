class StructuredFieldsController < ApplicationController
  before_action :set_schema
  before_action :set_field, only: %i[destroy]

  def create
    @field = @schema.structured_fields.create(field_params)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to edit_structured_schema_path(@schema) }
    end
  end

  def destroy
    @field.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to edit_structured_schema_path(@schema) }
    end
  end

  # PATCH /structured_schemas/:schema_id/fields/reorder
  def reorder
    params[:order].each_with_index do |id, index|
      StructuredField.where(id: id).update_all(position: index + 1)
    end

    head :ok
  end

  private

  def set_schema
    @schema = StructuredSchema.find(params[:structured_schema_id])
  end

  def set_field
    @field = @schema.structured_fields.find(params[:id])
  end

  def field_params
    params.require(:structured_field).permit(
      :key, :data_type, :item_type, :enum_values, :required, :description
    )
  end
end

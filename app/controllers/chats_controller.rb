class ChatsController < ApplicationController
  before_action :set_chat, only: [ :show, :edit_schema, :update_schema ]

  def index
    @chats = Chat.order(created_at: :desc)
  end

  def show
  end

  def create
    @chat = Chat.create!
    redirect_to @chat
  end

  def edit_schema
    @schemas = StructuredSchema.order(:name)
    render layout: false
  end

  def update_schema
    @chat.update!(schema_params)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "schema_panel_#{@chat.id}",
          partial: "schema_panel",
          locals: { chat: @chat }
        )
      end

      format.html { redirect_to @chat }
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def schema_params
    params.require(:chat).permit(:structured_schema_id)
  end
end

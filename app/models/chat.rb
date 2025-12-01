class Chat < ApplicationRecord
  serialize :context, coder: JSON, type: Array
  belongs_to :structured_schema, optional: true
  has_many :messages, dependent: :destroy
  after_create_commit :broadcast_chat

  def broadcast_chat
    broadcast_append_to(:chats, target: "chats", partial: "chats/chat", locals: { chat: self })
  end
end

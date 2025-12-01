class AddStructuredSchemaToChats < ActiveRecord::Migration[7.2]
  def change
    add_column :chats, :structured_schema_id, :integer
  end
end

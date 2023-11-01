class AddAnswerAndSourcesToChats < ActiveRecord::Migration[7.0]
  def change
    add_column :chats, :answer, :string
    add_column :chats, :sources, :string
  end
end

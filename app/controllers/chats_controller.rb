class ChatsController < ApplicationController
  skip_forgery_protection only: [:create]
  skip_before_action :authenticate_user!, only: [:create]

  def create
    chat = Chat.new(chat_params)

    unless Chat.all.map(&:id).include?(chat.id)
      chat.answer = chat.reply["answer"]
      chat.sources = chat.reply["sources"].join(" | ")
      chat.save
    end

    redirect_to chat, status: :ok
  end

  private

  def chat_params
    params.require(:chat).permit(:id, :uuid, :prompt, :created_at, :updated_at, reply: {})
  end
end

class ChatsController < ApplicationController
  wrap_parameters Chat
  def index
    render json: Chat.all
  end

  def create
    chat = Chat.new(chat_params)

    if chat.save
      render json: chat, status: :created
    else
      render json: chat.errors, status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:id, :uuid, :prompt, :reply, :created_at, :updated_at)
  end
end


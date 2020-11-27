class MessagesController < ApplicationController
  before_action :set_receiver, only: [:new, :create]

  def new
    @message = Message.new
    
    received_by_current = current_user.received.where(sender_id: @receiver.id)
    sent_by_current = @receiver.received.where(sender_id: current_user.id)
    @messages = (sent_by_current + received_by_current).sort_by(&:created_at)    
  end

  def create
    @message = Message.new(message_params)
    
    @message.recipient_id = params[:recipient]     
    @message.sender_id = current_user.id

    if @message.save
      received_by_current = current_user.received.where(sender_id: params[:user_id])
      sent_by_current = @receiver.received.where(sender_id: current_user.id)

      @messages = (sent_by_current + received_by_current).sort_by(&:created_at)
      
      redirect_to new_user_message_path(@receiver.id)
    else
      flash[:notice] = @message.errors.full_messages.to_sentence
    end
  end

  private
    def message_params
      params.require(:message).permit(:message)
    end

    def set_receiver
      @receiver = User.find(params[:user_id])
    end
end
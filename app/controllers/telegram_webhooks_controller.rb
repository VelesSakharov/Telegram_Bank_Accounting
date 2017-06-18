class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  def start(*args)
    keyboard
    respond_with :message, text: "Please enter that value in User edit page: #{from['id']}"
  end

  def all(*args)
    @user = User.find_by(telegram_id: from['id'])
    @notes = Note.where(user_id: @user.id)
    @notes.each do |reply|
      respond_with :message, text: "#{reply[:title]}: #{reply[:content]}! Appointment: #{reply[:appointment]}"
    end
  end

  def remind
    @user = User.find_by(telegram_id: from['id'])
    @replies = TelegramService.new.get_new_notes(@user.id)
    @replies.each do |reply|
      respond_with :message, text: "#{reply[:title]}: #{reply[:content]}! Appointment: #{reply[:appointment]}"
    end
  end

  def keyboard(value = nil, *)

    if value
      respond_with :message, text: "You've selected: #{value}"
    else
      save_context :keyboard
      respond_with :message, text: "Now You're using keyboard", reply_markup: {
          keyboard:[ %W(/all /keyboard /remind)
          ],
          resize_keyboard: true,
          one_time_keyboard: false,
          selective: true
      }
    end
  end

  def message(message)
    respond_with :message, text: "#{message['text']}"
  end

  private

  def fetch_update_params
    a =
        update["update_id"],
            update["message"]["message_id"],
            update["message"]["from"],
            update["message"]["chat"],
            update["message"]["date"],
            update["message"]["text"],
            update["message"]["entities"]
  end

  def perform
  end
end

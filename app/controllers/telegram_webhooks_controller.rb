class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  def start(*args)
    keyboard
    if(User.find_by(telegram_id: from['id']))
      respond_with :message, text: "Hello #{User.find_by(telegram_id: from['id']).user_name}! Welcome back!"
    else
      @user = User.new(telegram_id: from['id'])
      @user.save
      respond_with :message, text: "Add your Nick :)"
      @@session = Hash.new
      @@session[from['id'].to_s.to_sym] = "Wait_nick"
    end
  end

  def all(*args)
    @user = User.find_by(telegram_id: from['id'])
    @accounts = Account.where(user_id: @user.id)
    keyboard = []
    @accounts.each do |reply|
      keyboard.push(reply.name)
    end

      respond_with :message, text: "List of Your accounts", reply_markup: {
          keyboard:[ keyboard
          ],
          resize_keyboard: true,
          one_time_keyboard: true,
          selective: true
      }
    #"#{reply[:title]}: #{reply[:content]}! Appointment: #{reply[:appointment]}"
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
          keyboard:[ %W(/start /all /keyboard /remind /add_account)
          ],
          resize_keyboard: true,
          one_time_keyboard: false,
          selective: true
      }
    end
  end

  #TODO: Add switch-case for that method
  def message(message)
    if @@session[from['id'].to_s.to_sym] == "Wait_nick"
      @@session.delete(from['id'])
      @user = User.find_by(telegram_id: from['id'])
      @user.user_name = message['text']
      @user.save
      respond_with :message, text: "Welcome #{message['text']}!"
    end
    if @@session[from['id'].to_s.to_sym] == "Wait_account"
      @@session.delete(from['id'].to_s.to_sym)
      @account = Account.new(name: message['text'], user_id: User.find_by(telegram_id: from['id']).id)
      @account.save
      respond_with :message, text: "Account #{message['text']} succesfully added :)"
    end

  end

  def add_account
    send_method_responce("Add name to Your account: ")
    @@session = Hash.new
    @@session[from['id'].to_s.to_sym] = "Wait_account"
  end

  private

  def send_method_responce(message)
    respond_with :message, text: "#{message}"
  end

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

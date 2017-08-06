class TelegramService

  TELEGRAM_ATTRIBUTES = %i(title content appointment).freeze

  def initialize
    @notes = Note.all.to_a
  end

  def get_notes
    @telegram_notes = []
    @notes = @notes.sort_by {|obj| obj.date_appointment}
    @notes.each do |note|
      @telegram_notes.push format_notes(note)
    end
    @telegram_notes
  end
  def get_new_notes(user_id)
    @telegram_notes = []
    @notes = @notes.sort_by {|obj| obj.appointment}
    @notes.each do |note|
      if note.appointment >= Time.now && note.user_id == user_id
        @telegram_notes.push format_notes(note)
      end
    end
    @telegram_notes
  end

  private

  def format_notes(note)
    notes_hash = {}
    notes_hash.tap do |attributes|
      attributes[:title] = note.title
      attributes[:content] = note.content
      attributes[:appointment] = note.appointment
    end
  end
end

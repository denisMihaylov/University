module Log4Ruby
  class Handler

    private

    def parse_message(message)
      format_message(message)
      formatter = Config.message_formatters[@type]
      formatter[:parts].map do |log_part|
        message.send(log_part)
      end.compact.join(formatter[:delimiter])
    end

    def format_message(message)
      message.time = message.time.strftime(Config.time_formatters[@type])
    end

  end
end

module Log4Ruby
  class Handler

    private

    def parse_message(message, logger_type)
      message.time = message.time.strftime(Config.time_formatters[logger_type])
      formatter = Config.message_formatters[logger_type]
      formatter[:parts].map do |log_part|
        message.send(log_part)
      end.compact.join(formatter[:delimiter])
    end

  end
end

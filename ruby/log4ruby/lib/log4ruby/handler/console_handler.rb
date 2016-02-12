require_relative '../handler'

module Log4Ruby
  class ConsoleHandler < Handler

    def initialize
      @processed_messages = []
    end

    def log_message(message)
      puts message.parse
      @processed_messages << message
    end

    def each_message(filter_hash)
      @processed_messages.each do |message|
        yield message if message_found?(message, filter_hash)
      end
    end

    private

    def message_found?(message, filter_hash)
      filter_hash.any? do |key, value|
        compare_values(message.send(key), value)
      end
    end

    def compare_values(message_value, filter_value)
      filter_value === message_value ||
      message_value.to_s.include?(filter_value.to_s)
    end

  end
end

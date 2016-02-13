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
        yield message if message.satisfy?(filter_hash)
      end
    end

  end
end

module Log4Ruby
  class FileHandler < Handler
    attr_accessor :rolling

    def initialize(rolling = true)
      @rolling = rolling
      Dir.mkdir('log') unless Dir.exists?('log')
    end

    def log_message(message)
      File.open('log/log_trace.log', 'a+') do |file|
        file.puts(parse_message(message, :file))
      end
    end

  end
end

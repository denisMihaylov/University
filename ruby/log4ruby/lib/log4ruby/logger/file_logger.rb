module Log4Ruby
  class FileLogger < Logger

    private

    def log(level, message, exception)
      Store.instance.push(LogMessage.new(@id, level, message, :file, exception))
    end

  end
end

module Log4Ruby
  class Syslog < Logger

    def log(level, message, exception)
      Store.instance.push(LogMessage.new(@id, level, message, :syslog, exception))
    end

    def log_remote(level, message, exception)
      Store.instance.push(LogMessage.new(@id, level, message, :remote, exception))
    end

  end
end

module Log4Ruby
  class ConsoleLogger < Logger
    
    private 

    def log(level, message, exception)
      message = LogMessage.new(@id, level, message, :console, exception)
      Store.instance.push(message)
    end

  end
end

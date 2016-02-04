module Log4Ruby
  class ConsoleLogger < Logger
    
    private 

    def log(level, message, exception)
      Store.instance.push(LogMessage.new(level, message, :console, exception))
    end

  end
end

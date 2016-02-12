module Log4Ruby
  LEVELS = [
    :off,     #Intended to turn off logging
    :fatal,   #Severe error events that can lead to application abortion
    :alert,   #Errors that should be corrected immediately
    :crit,    #Critical conditions
    :error,   #Error events that presumably allow the application to continue
    :unknown, #Logs a message for an unknown reason
    :warn,    #Warn events for potentially harmful situations
    :info,    #Info events for information messages
    :debug,   #Debug events to enable debuging of the application
    :all,     #Intended to turn on all logging
  ]
end

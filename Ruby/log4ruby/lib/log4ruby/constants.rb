module Log4Ruby
  LEVELS = [
    :off,   #Intended to turn off logging
    :fatal, #Severe error events that can lead to application abortion
    :error, #Error events that presumably allow the application to continue
    :warn,  #Warn events for potentially harmful situations
    :info,  #Info events for information messages
    :debug, #Debug events to enable debuging of the application
    :all,   #Intended to turn on all logging
  ]
  CONFIG_PATH = File.join(File.dirname(__FILE__), 'config')
end

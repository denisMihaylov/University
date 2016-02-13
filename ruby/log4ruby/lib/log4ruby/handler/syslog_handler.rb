require_relative 'system_loggable.rb'
require_relative '../handler'

module Log4Ruby
  # Basic syslog handler that allows logging the system log
  class SyslogHandler < Handler
    include SystemLoggable

    def initialize
      @type = :syslog
    end

    def log_message(message)
      level = get_level(message.level)
      facility = '-p %s.%s'.format [message.logger_id.to_s, level]
      call_bash_logging(facility, message.parse)
    end
  end
end

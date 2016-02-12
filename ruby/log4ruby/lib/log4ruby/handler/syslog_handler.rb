require_relative 'system_loggable.rb'

module Log4Ruby
  class SyslogHandler < Handler
    include SystemLoggable

    def initialize
      @type = :syslog
    end

    def log_message(message)
      level = get_level(message.level)
      facility = "-p %s.%s" % [message.logger_id.to_s, level]
      call_bash_logging(facility, message.parse)
    end

  end
end

require_relative 'system_loggable.rb'

module Log4Ruby
  class RemoteSyslogHandler < Handler
    include SystemLoggable

    def initialize
      @type = :remote
    end

    def log_message(message)
      level = get_level(message.level)
      facility = "-n %s" % Config.syslog[:remote_host]
      message = parse_message(message)
      call_bash_logging(facility, message)
    end

  end
end

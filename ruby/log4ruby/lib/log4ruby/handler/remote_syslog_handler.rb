require_relative 'system_loggable.rb'
require_relative '../handler'
require_relative '../config'

module Log4Ruby
  class RemoteSyslogHandler < Handler
    include SystemLoggable

    def initialize
      @type = :remote
    end

    def log_message(message)
      level = get_level(message.level)
      parts = [Config.syslog[:remote_host], message.logger_id.to_s, level]
      facility = "-n %s.%s -p %s" % parts
      message = message.parse
      call_bash_logging(facility, message)
    end

  end
end

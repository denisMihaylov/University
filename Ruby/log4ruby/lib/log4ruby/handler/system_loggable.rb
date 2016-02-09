module Log4Ruby
  module SystemLoggable
    LEVEL_MAPPER = {
      :fatal => :crit,
      :error => :err,
      :unknown => :alert,
      :warn => :warning,
    }

    def call_bash_logging(facility, message)
      %x[logger #{facility} '#{message}']
    end

    def get_level(level)
      LEVEL_MAPPER[level] || level
    end

  end
end

require 'log4ruby/version'
require 'log4ruby/constants'
require 'log4ruby/config'
require 'log4ruby/error'
require 'log4ruby/message'
require 'log4ruby/logger'
require 'log4ruby/store'
require 'log4ruby/handler'
require 'log4ruby/logger_provider'
require 'log4ruby/handler_registry'

Log4Ruby::HandlerRegistry.init_handlers
Thread.new do
  begin
  Log4Ruby::HandlerRegistry.start_logging
  rescue => e
    p e
    p e.backtrace.take(5)
  end
end

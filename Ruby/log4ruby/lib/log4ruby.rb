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

Thread.new do
  Log4Ruby::HandlerRegistry.start_logging
end

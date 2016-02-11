require_relative 'log4ruby/version'
require_relative 'log4ruby/constants'
require_relative 'log4ruby/config'
require_relative 'log4ruby/error'
require_relative 'log4ruby/message'
require_relative 'log4ruby/logger'
require_relative 'log4ruby/handler'
require_relative 'log4ruby/logger_provider'
require_relative 'log4ruby/handler_registry'

Log4Ruby::HandlerRegistry.init_handlers

require 'log4ruby/version'
require 'log4ruby/config'
require 'log4ruby/constants'
require 'log4ruby/message'
require 'log4ruby/logger'
require 'log4ruby/store'
require 'log4ruby/handler'
require 'log4ruby/logger_provider'

Thread.new do
  Log4Ruby::Handler.start_logging
end

require 'log4ruby/version'
require 'log4ruby/logger'
require 'log4ruby/store'
require 'log4ruby/handler'
require 'log4ruby/logger_provider'

Thread.new do
handler = Log4Ruby::Handler.new
  loop do
    handler.log_message
  end
end

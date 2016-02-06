require 'log4ruby/version'
Gem::Specification.new do |s|
  s.name        = 'Log4Ruby'
  s.version     = Log4Ruby::VERSION
  s.date        = '2015-04-28'
  s.summary     = 'Logger for ruby'
  s.description = 'A simple logger for ruby gem'
  s.authors     = ['Denis Mihaylov']
  s.email       = 'denis.mihaylov93@gmail.com'
  s.files       = [
    'lib/log4ruby.rb', 
    'lib/log4ruby/version.rb',
    'lib/log4ruby/logger.rb',
    'lib/log4ruby/handler.rb',
    'lib/log4ruby/logger_provider.rb',
    'lib/log4ruby/store.rb',
    'lib/log4ruby/constants.rb',
    'lib/log4ruby/message.rb',
    'lib/log4ruby/config.rb',
    'lib/log4ruby/error.rb',
    'lib/log4ruby/handler_registry.rb',
    'lib/log4ruby/logger/console_logger.rb',
    'lib/log4ruby/logger/file_logger.rb',
    'lib/log4ruby/logger/db_logger.rb',
    'lib/log4ruby/handler/console_handler.rb',
    'lib/log4ruby/handler/file_handler.rb',
    'lib/log4ruby/handler/db_handler.rb',
    'lib/log4ruby/handler/sqlite3_handler.rb',
    'lib/log4ruby/util/sql_utils.rb',
  ] + Dir['lib/log4ruby/config/*']
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'MIT'
end

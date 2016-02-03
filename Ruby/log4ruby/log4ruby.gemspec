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
    'lib/log4ruby/logger/console_logger.rb',
    'lib/log4ruby/store.rb',
    'lib/log4ruby/constants.rb',
    'lib/log4ruby/message.rb',
    
  ]
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'MIT'
end

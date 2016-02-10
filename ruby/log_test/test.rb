require 'log4ruby'

#logger = Log4Ruby.file_logger
#logger.info('Message')
#p Log4Ruby::Config.settings
logger = Log4Ruby.sqlite3_logger("logger")


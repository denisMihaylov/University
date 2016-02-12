require_relative '../lib/log4ruby/logger_provider'

describe 'Log4Ruby - logger providing methods' do

  describe '#console_logger' do
    it "creates a 'console' logger" do
      logger = Log4Ruby.console_logger("LOGGER ID", :warn)
      expect(logger.handler).to eq :console
      expect(logger.level).to eq :warn
    end

    it "creates a 'console' logger with default level 'INFO'" do
      logger = Log4Ruby.console_logger("LOGGER ID")
      expect(logger.level).to eq :info
    end
  end

  describe '#file_logger' do
    it "creates a 'file' logger" do
      logger = Log4Ruby.file_logger("LOGGER ID", :error)
      expect(logger.handler).to eq :file
      expect(logger.level).to eq :error
    end
  end 

  describe '#syslog_logger' do
    it "creates a 'syslog' logger" do
      logger = Log4Ruby.syslog_logger("LOGGER ID", :debug)
      expect(logger.handler).to eq :syslog
      expect(logger.level).to eq :debug
    end
  end

  describe '#remote_logger' do
    it "creates a 'remote' logger" do
      logger = Log4Ruby.remote_logger("LOGGER ID", :crit)
      expect(logger.handler).to eq :remote
      expect(logger.level).to eq :crit
    end
  end

  let(:registry) {Log4Ruby::HandlerRegistry}

  describe '#sqlite3_logger' do
    it "creates a 'sqlite3' logger and registers a handler" do
      expect(registry.handles?(:sqlite3)).to be false
      logger = Log4Ruby.sqlite3_logger("LOGGER ID")
      expect(logger.handler).to eq :sqlite3
      expect(logger.level).to eq :info
      expect(registry.handles?(:sqlite3)).to be true
    end
  end

  describe '#postgresql_logger' do
    it "creates a 'postgresql' logger and registers a handler" do
      expect(registry.handles?(:postgresql)).to be false
      logger = Log4Ruby.postgresql_logger("LOGGER ID")
      expect(logger.handler).to eq :postgresql
      expect(logger.level).to eq :info
      expect(registry.handles?(:postgresql)).to be true
    end
  end

  describe '#mysql_logger' do
    it "creates a 'mysql' logger and registers a handler" do
      expect(registry.handles?(:mysql)).to be false
      logger = Log4Ruby.mysql_logger("LOGGER ID")
      expect(logger.handler).to eq :mysql
      expect(logger.level).to eq :info
      expect(registry.handles?(:mysql)).to be true
    end
  end
end

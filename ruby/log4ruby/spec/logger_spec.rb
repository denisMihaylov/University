require_relative '../lib/log4ruby/logger'

describe Log4Ruby::Logger do

  let(:default_types) {[:console, :file, :syslog, :remote]}
  let(:db_tupes) {[:sqlite3, :postgresql, :mysql]}
  let(:levels) {Log4Ruby::LEVELS[1..-2]}

  before(:all) do
    @logger = Log4Ruby::Logger.new("LOGGER ID", :info, :console)
  end

  describe '#initialize' do
    it 'sets the id, level and handler of the logger' do
      expect(@logger.id).to eq "LOGGER ID"
      expect(@logger.level).to eq :info
      expect(@logger.handler).to eq :console
    end
  end

  describe '#is_logging_allowed?' do
    context 'when the logger level is :info' do
      it 'debug is not allowed' do
        expect(@logger.debug_enabled?).to be false
      end

      it 'all other levels are allowed' do
        levels.select {|level| level != :debug}.each do |level|
          expect(@logger.send("#{level}_enabled?")).to be true
        end
      end
    end

    context 'when the logger level is :error' do
      before(:all) do
        @logger.level = :error
      end

      it 'debug is not allowed' do
        expect(@logger.debug_enabled?).to be false
      end

      it 'info is not allowed' do
        expect(@logger.info_enabled?).to be false
      end

      it 'warn is not allowed' do
        expect(@logger.warn_enabled?).to be false
      end

      it 'unknown is not allowed' do
        expect(@logger.unknown_enabled?).to be false
      end

      it 'all other levels are allowed' do
        levels.take_while {|level| level != :error}.each do |level|
          expect(@logger.send("#{level}_enabled?")).to be true
        end 
      end 
    end

    context 'when the logger level is :off' do
      before(:all) do
        @logger.level = :off
      end

      it 'all levels are not allowed' do
        levels.each do |level|
          expect(@logger.send("#{level}_enabled?")).to be false
        end
      end
    end

    context 'when the logger level is :all' do
      before(:all) do
        @logger.level = :all
      end

      it 'all levels are allowed' do
        levels.each do |level|
          expect(@logger.send("#{level}_enabled?")).to be true
        end
      end
    end
  end

  describe 'logging methods' do
    context 'when the logger level is :alert' do
      before(:all) do
        @logger.level = :alert
      end

      it 'should log alert messages' do
        expect(@logger).to receive(:log)
        @logger.alert("alert")
      end

      it 'should log fatal messages' do
        expect(@logger).to receive(:log)
        @logger.fatal("fatal")
      end

      it 'should not log all other messages' do
        expect(@logger).not_to receive(:log)
        levels[2..-1].each {|level| @logger.send(level, "message")}
      end
    end

    context 'when the logger level is :info' do
      before(:all) do
        @logger.level = :info
      end

      it 'should not log debug messages' do
        expect(@logger).not_to receive(:log)
        @logger.debug("message")
      end

      it 'should log all other messages' do
        levels[0..-2].each do |level|
          expect(@logger).to receive(:log)
          @logger.send(level, "message")
        end
      end
    end
  end
end

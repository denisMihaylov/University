require_relative '../lib/log4ruby/handler_registry'
require_relative '../lib/log4ruby/message'
require_relative '../lib/log4ruby/config'
require_relative 'exception_helper'

describe Log4Ruby::Handler do
  before(:all) do
    @config = Log4Ruby::Config
    @registry = Log4Ruby::HandlerRegistry
    @message = Log4Ruby::LogMessage.new do
      @logger_id = "logger_id"
      @level = :info
      @message = "message"
      self.exception = get_exception
    end
  end

  context Log4Ruby::ConsoleHandler do
    it 'logs a message to the standard output' do
      @message.type = :console
      expect do
        @registry.log_message(@message)
      end.to output(@message.parse + "\n").to_stdout
    end
  end

  context Log4Ruby::FileHandler do
    before(:all) do
      @handler = @registry.handlers[:file]
      @handler.rolling = false
      @message.type = :file
      @file_path = @handler.get_file_name
    end

    before(:each) do
      entries = Dir.entries(@config.file[:file_path]) - ['.', '..']
      FileUtils.rm_rf(entries)
    end

    it 'logs a message to a file' do
      @registry.log_message(@message)
      expect(File.exist?(@file_path)).to be true
      File.open(@file_path, 'r') do |file|
       expect(file.gets).to eq(@message.parse + "\n")
      end
    end

  end
end

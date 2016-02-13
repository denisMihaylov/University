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
      @file_entries = lambda do
        Dir.entries(@config.file[:file_path]) - ['.', '..']
      end
    end

    before(:each) do
      @file_entries.call.each do |entry|
        FileUtils.rm_rf(File.join(@config.file[:file_path], entry))
      end
    end

    it 'logs a message to a file' do
      @registry.log_message(@message)
      expect(File.exist?(@file_path)).to be true
      File.open(@file_path, 'r') do |file|
       expect(file.gets).to eq(@message.parse + "\n")
      end
    end

    it 'does not perform the rolling if not configured' do
      expect(@handler).not_to receive(:perform_post_log_actions)
      @registry.log_message(@message)
    end

    context 'performs rolling by limits defined in the configuration' do
      before(:all) do
        @handler.rolling = true
      end

      it 'rolls the files when the messages count limit is exceeded' do
        @config.file[:limits][:message_count] = 2
        @registry.log_message(@message)
        expect(@file_entries.call).to include('log_trace.log')
      end
    end

  end
end

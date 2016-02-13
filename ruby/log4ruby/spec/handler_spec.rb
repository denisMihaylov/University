require_relative '../lib/log4ruby/handler_registry'
require_relative '../lib/log4ruby/handler/sqlite3_handler'
require_relative '../lib/log4ruby/handler/postgresql_handler'
require_relative '../lib/log4ruby/handler/mysql_handler'
require_relative '../lib/log4ruby/logger_provider'
require_relative '../lib/log4ruby/message'
require_relative '../lib/log4ruby/config'
require_relative 'exception_helper'

describe Log4Ruby::Handler do
  before(:all) do
    @config = Log4Ruby::Config
    @registry = Log4Ruby::HandlerRegistry
    @message = Log4Ruby::LogMessage.new do
      @logger_id = "logger_id"
      @time = Time.now
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

    after(:all) do
      FileUtils.rm_rf(@config.file[:file_path])
    end

    before(:each) do
      @file_entries.call.each do |entry|
        FileUtils.rm_rf(File.join(@config.file[:file_path], entry))
      end
      @handler.read_file_stats
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

      it 'rolls the files if the messages count limit is exceeded' do
        @config.file[:limits][:message_count] = 2

        @registry.log_message(@message)
        current_entries = @file_entries.call

        expect(current_entries).to include('log_trace.log')
        expect(current_entries).to include('.stats.yaml')

        @registry.log_message(@message)
        current_entries = @file_entries.call

        expect(current_entries).not_to include('log_trace.log')
        expect(current_entries).to include('log_trace.log1')
        expect(current_entries).to include('.stats.yaml')

        3.times {@registry.log_message(@message)}
        current_entries = @file_entries.call

        expect(current_entries).to include('log_trace.log')
        expect(current_entries).to include('log_trace.log1')
        expect(current_entries).to include('log_trace.log2')

        @config.file[:limits][:message_count] = 20
      end

      it 'rolls the files if the file size is exceeded' do
        @config.file[:limits][:file_size] = 50
        @config.file[:limits][:size_unit] = :byte

        @registry.log_message(@message)
        current_entries = @file_entries.call

        expect(current_entries).not_to include('log_trace.log')
        expect(current_entries).to include('log_trace.log1')

        @config.file[:limits][:file_size] = 1_000_000
      end

      it 'rolls the files if the time is exceeded' do
        @config.file[:limits][:time] = 1
        @config.file[:limits][:time_unit] = :millis

        @registry.log_message(@message)
        current_entries = @file_entries.call

        expect(current_entries).not_to include('log_trace.log')
        expect(current_entries).to include('log_trace.log1')

        @config.file[:limits][:time] = 1
        @config.file[:limits][:time_unit] = :day
      end
    end
  end

  shared_examples 'db_handlers' do |type|
    it 'is registered when a logger is created' do
      expect(@registry.handlers[type]).to be nil
      Log4Ruby.send("#{type}_logger", "LOGGER_ID")
    end
  end

  context Log4Ruby::SQLite3Handler do
    before(:each) do
      @message.type = :sqlite3
      @handler = @registry.handlers[:sqlite3]
      @count_rows = lambda do
        db = SQLite3::Database.open(@handler.db_name)
        db.get_first_value("SELECT COUNT (*) FROM LOG")
      end
    end

    include_examples 'db_handlers', :sqlite3

    it 'logs messages in a sqlite3 database' do
      expect(@count_rows.call).to eq 0
      3.times {@registry.log_message(@message)}
      expect(@count_rows.call).to eq 3
      FileUtils.rm_rf(@handler.db_name)
    end
  end
end

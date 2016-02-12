require_relative '../lib/log4ruby/message'
require_relative 'exception_helper'

describe Log4Ruby::LogMessage do
  before :each do
    @exception = get_exception
    @message = Log4Ruby::LogMessage.new do
      @logger_id = "logger_id"
      @level = :info
      @message = "message"
      @type = :console
      self.exception = Exception.new
    end
  end

  describe "#initialize" do
    it "creates a new LogMessage" do
      expect(@message.logger_id).to eq "logger_id"
      expect(@message.level).to eq :info
      expect(@message.message).to eq "message"
      expect(@message.type).to eq :console
      expect(@message.exception).to eq Exception.new
      expect(@message.backtrace).to eq nil
    end
  end

  describe "#exception=" do
    it "sets the exception and the backtrace" do
      console_formatters = Log4Ruby::Config.message_formatters[:console]
      back_trace_depth = console_formatters[:backtrace_depth]
      @message.exception = @exception
      expect(@message.backtrace.size).to eq back_trace_depth
    end
  end

end


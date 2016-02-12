require_relative '../lib/log4ruby/message'
require_relative 'exception_helper'

describe Log4Ruby::LogMessage do

  let(:config) {Log4Ruby::Config}

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
      expect(@message.level).to eq "INFO"
      expect(@message.message).to eq "message"
      expect(@message.type).to eq :console
      expect(@message.exception).to eq Exception.new
      expect(@message.backtrace).to eq nil
      expect(@message.time_date).to be_within(1).of(Time.now)
    end
  end

  describe "#exception=" do
    it "sets the exception and the backtrace" do
      console_formatters = config.message_formatters[:console]
      back_trace_depth = console_formatters[:backtrace_depth]
      @message.exception = @exception
      expect(@message.backtrace.size).to eq back_trace_depth
    end
  end

  describe "#parse" do
    it "formats the message depending on the configuration" do
      parsed = @message.parse
      formatter = config.message_formatters[@message.type]
      parts = parsed.split(formatter[:delimiter])
      parts.each_with_index do |part, index|
        expect(part).to eq @message.send(formatter[:parts][index]).to_s
      end
      @message.type = :some_non_existing
      expect(@message.parse).not_to eq parsed
    end
  end

end


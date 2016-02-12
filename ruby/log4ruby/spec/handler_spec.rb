require_relative '../lib/log4ruby/handler_registry'

describe Log4Ruby::HandlerRegistry do

  let(:registry) {Log4Ruby::HandlerRegistry}
  let(:error) {Log4Ruby::HandlerRegistryError}
  let(:new_handler) {Log4Ruby::ConsoleHandler.new}

  shared_examples 'type_to_handler' do |type, handler_class|
    it "should register '#{type}' handler" do
      handler = registry.handlers[type]
      expect(handler).to be_kind_of(handler_class)
    end
  end

  describe '#init_handlers' do
    it 'creates 4 initial handler' do
      expect(registry.handlers.size).to eq 4
    end

    include_examples 'type_to_handler', :console, Log4Ruby::ConsoleHandler
    include_examples 'type_to_handler', :file, Log4Ruby::FileHandler
    include_examples 'type_to_handler', :syslog, Log4Ruby::SyslogHandler
    include_examples 'type_to_handler', :remote, Log4Ruby::RemoteSyslogHandler
  end

  describe '#register' do
    it 'registers a new handler' do
      registry.register(:new_type, new_handler)
      expect(registry.handlers[:new_type]).to eq new_handler
    end

    it 'cannot register if the logger type has a defined handler' do
      old_handler_count = registry.handlers.size
      registry.register(:new_type, new_handler)
      expect(registry.handlers.size).to eq old_handler_count
    end

    it 'defines logger providing methods' do
      expect(Log4Ruby).to respond_to(:new_type_logger)
      logger = Log4Ruby.new_type_logger("LOGGER ID")
      expect(logger.handler).to eq :new_type

      expect(Log4Ruby).not_to respond_to(:new_logger_type)
      registry.register(:new_logger_type, new_handler)
      expect(Log4Ruby).to respond_to(:new_logger_type)
    end
  end

  describe '#deregister' do
    it 'removes a handler for the specified logger type' do
      registry.deregister(:new_type)
      expect(registry.handlers[:new_type]).to eq nil
    end

    it 'throws an exception if there is no handler to remove' do
      expect {registry.deregister(:new_type)}.to raise_error(error)
    end
  end

  describe '#register!' do
    it 'registers a new handler' do
      registry.register!(:new_type, new_handler)
      expect(registry.handlers[:new_type]).to eq new_handler
    end

    it 'throws an exception if there is a handler fot that logger type' do
      expect {registry.register!(:new_type, new_handler)}.to raise_error(error)
    end
  end

  describe '#update_handler' do
    it 'updates an existing handler' do
      new_handler = Log4Ruby::FileHandler.new
      registry.update_handler(:new_type, new_handler)
      expect(registry.handlers[:new_type]).to eq new_handler
    end

    it 'throws an exception when updating an non-existing handler' do
      registry.deregister(:new_type)
      expect do
        registry.update_handler(:new_type, new_handler)
      end.to raise_error(error)
    end
  end
end

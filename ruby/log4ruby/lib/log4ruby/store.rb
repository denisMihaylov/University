require 'singleton'
require 'thread'

class Log4Ruby::Store
  include Singleton

  def push(message)
    @queue << message
  end

  def pop
    @queue.pop
  end

  def init
    @queue = Queue.new
  end

end

Log4Ruby::Store.instance.init

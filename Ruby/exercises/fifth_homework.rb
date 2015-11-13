require 'time'
require 'digest/sha1'

class Time

  def to_git_s
    offset_in_seconds = self.utc_offset
    sign = offset_in_seconds < 0 ? '-' : '+'
    minutes = offset_in_seconds.abs / 60
    hours = "%02d" % (minutes / 60)
    minutes = "%02d" % (minutes % 60)
    self.strftime("%a %b %d %H:%M:%S %Y ") + sign + hours + minutes
  end

end

class ObjectStore

  def self.init
    if block_given?
      Repository.new(&(proc))
    else
      Repository.new
    end 
  end

end

#repository class
class ObjectStore::Repository

  def initialize
    @objects = {}
    @adds_count = 0
    @commits_count = 
    instance_eval(&(proc)) if block_given?
  end

  def add(name, object)
    @objects[name] = object
    finalize_operation("Added #{name} to stage.", true, object)
  end

  def commit(message)
    date = Time.now
    result = finalize_operation("#{message}\n\t#{@adds_count} objects changed")
    @adds_count = 0;
    result
  end

  def remove(name)
    deleted_object = hash.delete(name)
    message = if deleted_object then
      "Object #{name} is not committed."
    else
      "Added #{name} for removal."
    end
    finalize_operation(message, deleted_object == nil, deleted_object)
  end

  private

  def finalize_operation(message, success, result)
    if success
      @count = @count + 1
    end
    OperationReturnObject.new(message, success, result)
  end

end

class ObjectStore::Repository::OperationReturnObject
  attr_reader :message, :result

  def initialize(message, success, result = nil)

  end

  def success?
    @success
  end

  def error?
    not success?
  end

  def result

  end

end

class ObjectStore::Commit

  def initialize(date, message)
    @date = date
    @message = message
  end

  def hash
    Digest::SHA1.hexdigest(date.to_git_s + message)
  end

end


require 'time'
require 'digest/sha1'

class Time

  def to_git_s
    offset_in_seconds = utc_offset
    sign = offset_in_seconds < 0 ? '-' : '+'
    minutes = offset_in_seconds.abs / 60
    hours = "%02d" % (minutes / 60)
    minutes = "%02d" % (minutes % 60)
    strftime("%a %b %02d %02H:%02M %Y ") + sign + hours + minutes
  end

end

class ObjectStore

  def self.init
    @repo = block_given? ? Repository.new(&(proc)) : Repository.new
  end

  def add(name, object)
    @repo.add(name, object)
  end

end

module ObjectStore::Operation

  class Result
    attr_reader :message, :result

    def initialize(message, success, result)
      @message = message
      @success = success
      @result = result
    end

    def success?
      @success
    end

    def error?
      not success?
    end

  end

  def operation_result(message, success = true, result = nil)
    Result.new(message, success, result)
  end

end

class ObjectStore::Repository
  include Enumerable
  include ObjectStore::Operation
  attr_accessor :staging_objects, :current_branch, :branch_to_head
  attr_writer :head

  def initialize
    @head = nil
    @current_branch = :master
    @branch_to_head = {}
    @staging_objects = {}
    update_branch
    instance_eval(&(proc)) if block_given?
  end

  def each
    iterator = @head
    until iterator.nil?
      yield iterator
      iterator = iterator.next
    end
  end

  def head
    if @head.nil?
      operation_result(no_commits_message, false, nil)
    else
      operation_result(@head.message, true, @head)
    end
  end

  def add(name, object)
    @staging_objects[name] = Object.new(name, object, :added)
    operation_result("Added #{name} to stage.", true, object)
  end

  def commit(message)
    if @staging_objects.size == 0
      result_message = "Nothing to commit, working directory clean."
      success = false
    else
      objects = @staging_objects.values
      @head = Commit.new(Time.now, message, objects, @head)
      update_branch
      result_message = "#{message}\n\t#{@staging_objects.size} objects changed"
      @staging_objects = {}
      success = true
    end
    operation_result(result_message, success, @head)
  end

  def remove(name)
    repo_object = latest_version_of_object(name)
    if repo_object.nil? or repo_object.removed?
      operation_result("Object #{name} is not committed.", false)
    else
      @staging_objects[name] = Object.new(name, repo_object.object, :removed)
      operation_result("Added #{name} for removal.", true, repo_object.object)
    end
  end

  def checkout(commit_hash)
    if commited?(commit_hash)
      @head = @head.next until @head.hash == commit_hash
      update_branch
      operation_result("HEAD is now at #{commit_hash}.", true, @head)
    else
      operation_result("Commit #{commit_hash} does not exist.", false)
    end
  end

  def branch
    @branch or @branch = Branch.new(self)
  end

  def log
    if count == 0
      operation_result(no_commits_message, false)
    else
      operation_result(to_a.join("\n\n"))
    end
  end

  def get(name)
    repo_object = latest_version_of_object(name)
    if repo_object.nil? or repo_object.removed?
      operation_result("Object #{name} is not committed.", false, nil)
    else
      operation_result("Found object #{name}.", true, repo_object.object)
    end
  end

  private

  def no_commits_message
    "Branch #{@current_branch.to_s} does not have any commits yet."
  end

  def commited?(commit_hash)
    any? {|commit| commit.hash == commit_hash}
  end

  def update_branch
    @branch_to_head[@current_branch] = @head
  end

  def latest_version_of_object(name)
    commit = find do |commit|
      commit.internal_objects.any? { |object| object.name == name }
    end
    commit.internal_objects.find do
      |object| object.name == name
    end unless commit.nil?
  end

end

class ObjectStore::Repository::Commit
  attr_accessor :date, :message, :internal_objects, :next

  def initialize(date, message, internal_objects, next_commit)
    @date = date
    @message = message
    @internal_objects = internal_objects
    @next = next_commit
  end

  def hash
    Digest::SHA1.hexdigest(date.to_git_s + message)
  end

  def to_s
    "Commit #{hash}\nDate: #{date.to_git_s}\n\n\t#{message}"
  end

  def objects(taken_objects = [])
    objects = @internal_objects.select do |object|
      (not taken_objects.include?(object.name)) and object.state == :added
    end
    @internal_objects.each {|object| taken_objects << object.name}
    next_objects = @next.nil? ? [] : @next.objects(taken_objects)
    objects.map {|object| object.object} + next_objects
  end

end

class ObjectStore::Repository::Branch
  include ObjectStore::Operation

  def initialize(parent_repo)
    @repo = parent_repo
  end

  def create(branch_name)
    if exists?(branch_name)
      operation_result("Branch #{branch_name} already exists.", false)
    else
      @repo.branch_to_head[branch_name.to_sym] = @repo.head.result
      operation_result("Created branch #{branch_name}.")
    end
  end

  def checkout(branch_name)
    if exists?(branch_name)
      @repo.head = @repo.branch_to_head[branch_name.to_sym]
      @repo.current_branch = branch_name.to_sym
      operation_result("Switched to branch #{branch_name}.")
    else
      operation_result("Branch #{branch_name} does not exist.", false)
    end
  end

  def remove(branch_name)
    current = list.message.include?("* " + branch_name)
    if exists?(branch_name) and current
      operation_result("Cannot remove current branch.", false)
    elsif exists?(branch_name)
      @repo.branch_to_head.delete(branch_name.to_sym)
      operation_result("Removed branch #{branch_name}.")
    else
      operation_result("Branch #{branch_name} does not exist.", false)
    end
  end

  def list
    list = @repo.branch_to_head.keys.map {|branch| branch.to_s}.sort
    list = "  #{list.join("\n  ")}"
    list[list.index(@repo.current_branch.to_s) - 2] = '*'
    operation_result(list)
  end

  private

  def exists?(branch_name)
    @repo.branch_to_head.keys.include?(branch_name.to_sym)
  end

end

class ObjectStore::Repository::Object
  attr_accessor :name, :object, :state

  def initialize(name, object, state)
    @name = name
    set_object(object)
    @state = state
  end

  def added?
    @state == :added
  end

  def removed?
    @state == :removed
  end

  def inspect
    "<@name = #@name, @object = #@object, @state = #{state}>"
  end

  private

  def set_object(object)
    @object = object.dup
  rescue Exception
    @object = object
  end

end

class RationalSequence
  include Enumerable

  def initialize(size = nil)
    @size = size
  end

  def each
    if @size.nil?
      enum_for(:each_rational).lazy.each {|rational| yield rational}
    else
      enum_for(:each_rational).lazy.take(@size).each {|rational| yield rational}    end
  end

  private

  def each_rational
    1.step do |number|
      sum = number * 2
      numerator_increasing(sum) {|x| yield x}
      denominator_increasing(sum + 1) {|x| yield x}
    end
  end

  def denominator_increasing(sum)
    1.upto(sum - 1) do |index|
      yield Rational(sum - index, index) if index.gcd(sum - index) == 1
    end
  end

  def numerator_increasing(sum)
    1.upto(sum - 1) do |index|
      yield Rational(index, sum - index) if index.gcd(sum - index) == 1
    end
  end

end

class Integer

  def prime?
    return false if self == 1
    Math.sqrt(self).floor.downto(2).each {|i| return false if self % i == 0}
    true
  end

end

class PrimeSequence
  include Enumerable

  def initialize(size)
    @size = size
  end

  def each
    enum_for(:each_prime).lazy.take(@size).each {|prime| yield prime}
  end

  private

  def each_prime
    1.step {|number| yield number if number.prime?}
  end

end

class FibonacciSequence
  include Enumerable

  def initialize(size, first: 1, second: 1)
    @size = size
    @first = first
    @second = second
  end

  def each
    current, previous, counter = @second, @first, 0
    while counter < @size
      yield previous
      current, previous, counter = current + previous, current, counter + 1
    end
  end

end

module DrunkenMathematician
  module_function

  def meaningless(n)
    sequence = RationalSequence.new(n)
    first_group = sequence.select {|rational| self.has_prime?(rational)}
    second_group = sequence.to_a - first_group
    first_group.reduce(1, :*) / second_group.reduce(1, :*)
  end

  def aimless(n)
    sequence = PrimeSequence.new(n)
    aimless_result = 0
    sequence.each_slice(2).reduce(0) {|sum, couple| self.next_sum(sum, couple)}
  end

  def worthless(n)
    limit = if n == 0 then
      0
    else
      FibonacciSequence.new(n).to_a.last
    end
    infinite_sequence = RationalSequence.new()
    sum = 0
    infinite_sequence.take_while do |rational|
      sum = sum + rational
      limit > sum
    end
  end

  def has_prime?(rational)
    rational.numerator.prime? or rational.denominator.prime?
  end

  def next_sum(sum, couple)
    sum + Rational(couple.fetch(0), couple.fetch(1, 1))
  end

end
